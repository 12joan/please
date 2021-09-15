# frozen_string_literal: true

module Please
  class Context
    def initialize(options)
      @examples = default_examples

      if options[:send_pwd]
        @examples << {
          instruction: 'Print the current working directory',
          command: 'pwd',
        }
      end

      if options[:send_uname]
        @examples << {
          instruction: 'Show information about the operating system',
          command: 'uname -a',
        }
      end

      if options[:send_ls]
        @examples << {
          instruction: 'List all files in the current directory',
          command: 'ls -a',
        }
      end
    end

    def to_s
      @examples.map do |example|
        <<~EXAMPLE.chomp
          # #{example[:instruction]}
          $ #{example[:command]}
          #{example.fetch(:result) { `#{example[:command]}` }}
        EXAMPLE
      end.join("\n")
    end

    private

    def default_examples
      [
        {
          instruction: 'Find all files older than 1 week and open each of them in vim',
          command: 'find . -type f -mtime +7 -exec vim {} \;',
          result: '',
        },

        {
          instruction: 'Download a random dog picture',
          command: 'printf \'import urllib.request\nimport json\nimport subprocess\ndata = urllib.request.urlopen("https://dog.ceo/api/breeds/image/random").read()\nurl = json.loads(data)["message"]\nsubprocess.call(["curl", url, "-o", "dog.jpg"])\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
          result: '',
        },

        {
          instruction: 'Read from stdin until EOF, and then output the length of the string',
          command: 'printf \'import sys\nprint(len(sys.stdin.read().strip()))\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
          result: '',
        },

        {
          instruction: 'Run the fortune command 5 times',
          command: 'for i in $(seq 5); do fortune; done',
          result: '',
        },

        {
          instruction: 'Repeadedly read a single line from the user, reverse it, and print it back',
          command: 'printf \'while True:\n\tline = input()\n\tprint(line[::-1])\' > /tmp/program.py; python3 /tmp/program.py; rm /tmp/program.py',
          result: '',
        },
      ]
    end
  end
end
