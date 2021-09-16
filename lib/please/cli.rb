# frozen_string_literal: true

require 'English'
require 'tty-prompt'
require 'yaml'
require 'optparse'
require 'please'
require 'tempfile'

USAGE = 'Usage: please [options] <instruction>'
CONFIG_FILE_PATH = File.expand_path('~/.config/please/config.yml')

begin
  tty_prompt = TTY::Prompt.new

  options = {
    show_prompt: false,
    send_pwd: true,
    send_uname: true,
    send_ls: true,
  }

  if File.exists?(CONFIG_FILE_PATH)
    begin
      options.merge! YAML.load_file(CONFIG_FILE_PATH).transform_keys(&:to_sym)
    rescue
      tty_prompt.warn 'Could not parse config file. Ignoring.'
    end
  end

  puts options.inspect

  OptionParser.new do |opts|
    opts.banner = USAGE

    opts.on('--show-config-path', 'Output the location of the config file, and then exit') do |v|
      options[:show_config_path] = v
    end

    opts.on('--show-prompt', 'Output the prompt that would ordinarily be sent to OpenAI Codex, and then exit') do |v|
      options[:show_prompt] = v
    end

    opts.on('--[no-]send-pwd', 'Send the result of `pwd` as part of the prompt') do |v|
      options[:send_pwd] = v
    end

    opts.on('--[no-]send-uname', 'Send the result of `uname -a` as part of the prompt') do |v|
      options[:send_uname] = v
    end

    opts.on('--[no-]send-ls', 'Send the result of `ls -a` as part of the prompt') do |v|
      options[:send_ls] = v
    end
  end.parse!

  if options[:show_config_path]
    tty_prompt.say CONFIG_FILE_PATH
    exit
  end

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

  context = Please::Context.new(options)

  request = Please::Request.new(
    instruction: instruction,
    context: context,
    codex_service: codex_service,
  )

  if options[:show_prompt]
    tty_prompt.say request.prompt
    exit
  end

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
      exit $CHILD_STATUS.exitstatus
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
rescue Interrupt
  exit 130
end
