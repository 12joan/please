# frozen_string_literal: true

require 'tty-prompt'
require 'optparse'
require 'please'
require 'tempfile'

tty_prompt = TTY::Prompt.new

options = {}

USAGE = 'Usage: please [options] <instruction>'

OptionParser.new do |opts|
  opts.banner = USAGE
end.parse!

access_token = ENV.fetch('OPENAI_ACCESS_TOKEN') do
  tty_prompt.error 'Ensure the OPENAI_ACCESS_TOKEN environment variable is set'
  exit 1
end

codex_service = Please::OpenAI::CodexService.new(access_token: access_token)

instruction = ARGV.join(' ')

if instruction.empty?
  tty_prompt.error USAGE
  exit 1
end

request = Please::Request.new(
  options: options,
  instruction: instruction,
  codex_service: codex_service,
)

command = request.send

loop do
  print '$ '
  tty_prompt.ok command

  action = tty_prompt.expand('Run the command?') do |q|
    q.choice key: 'y', name: 'Yes', value: :run
    q.choice key: 'n', name: 'No', value: :abort
    q.choice key: 'e', name: 'Edit command before running', value: :edit
  end

  case action
  when :run
    Process.wait spawn(command)
    exit $?.exitstatus
  when :abort
    break
  when :edit
    Tempfile.open('command') do |file|
      file << command
      file.flush

      Process.wait spawn("${EDITOR:-vi} #{file.path}")

      file.rewind
      command = file.read.chomp
    end
  end
end
