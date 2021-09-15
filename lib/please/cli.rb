# frozen_string_literal: true

require 'please'
require 'optparse'

options = {}

USAGE = 'Usage: please [options] <instruction>'

OptionParser.new do |opts|
  opts.banner = USAGE
end.parse!

instruction = ARGV.join(' ')

if instruction.empty?
  warn USAGE
  exit 1
end

request = Please::Request.new(options: options, instruction: instruction)

request.send! do |command|
  puts command
end
