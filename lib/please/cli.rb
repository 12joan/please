# frozen_string_literal: true

require 'please'
require 'optparse'

options = {}

USAGE = 'Usage: please [options] <instruction>'

OptionParser.new do |opts|
  opts.banner = USAGE
end.parse!

access_token = ENV.fetch('OPENAI_ACCESS_TOKEN') do
  warn 'Ensure the OPENAI_ACCESS_TOKEN environment variable is set'
  exit 1
end

codex_service = Please::OpenAI::CodexService.new(access_token: access_token)

instruction = ARGV.join(' ')

if instruction.empty?
  warn USAGE
  exit 1
end

request = Please::Request.new(
  options: options,
  instruction: instruction,
  codex_service: codex_service,
)

command = request.send
puts "$ #{command}"
