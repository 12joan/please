# frozen_string_literal: true

DEFAULT_EXAMPLES = [
  {
    instruction: 'Find all files older than 1 week and open each of them in vim',
    command: 'find . -type f -mtime +7 -exec vim {} \;',
  },

  {
    instruction: 'Show a clock which updates every second on a single line',
    command: 'printf \'import time\nwhile True:\n\tprint(time.strftime("%%H:%%M:%%S"), end="\\\\r")\n\ttime.sleep(1)\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
  },

  {
    instruction: 'Write a python program that prints out hello world with each letter on its own line',
    command: 'printf \'print("\\\\n".join(list("Hello World"))\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
  },

  {
    instruction: 'Read from stdin until EOF, and then output the length of the string',
    command: 'printf \'import sys\nprint(len(sys.stdin.read().strip()))\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
  },

  {
    instruction: 'Run the fortune command 5 times',
    command: 'for i in $(seq 5); do fortune; done',
  },

  {
    instruction: 'Repeadedly read a single line from the user, reverse it, and print it back',
    command: 'printf \'while True:\n\tline = input()\n\tprint(line[::-1])\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
  },
].freeze

OPTIONAL_EXAMPLES = {
  pwd: {
    instruction: 'Print the current working directory',
    command: 'pwd',
    execute: true,
  },

  uname: {
    instruction: 'Show information about the operating system',
    command: 'uname -a',
    execute: true,
  },

  ls: {
    instruction: 'List all files in the current directory',
    command: 'ls -a',
    execute: true,
  },
}.freeze

module Please
  class Context
    def initialize(options)
      @examples = []

      @examples += DEFAULT_EXAMPLES unless options[:skip_default_examples]

      @examples << OPTIONAL_EXAMPLES[:pwd] if options[:send_pwd]
      @examples << OPTIONAL_EXAMPLES[:uname] if options[:send_uname]
      @examples << OPTIONAL_EXAMPLES[:ls] if options[:send_ls]

      @examples += options[:examples]
    end

    def to_s
      @examples.map do |example|
        <<~EXAMPLE.chomp
          # #{example[:instruction]}
          $ #{example[:command]}
          #{example[:execute] ? `#{example[:command]}` : ""}
        EXAMPLE
      end.join("\n")
    end
  end
end
