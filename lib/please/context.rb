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
          command: 'python3 -c \'import urllib.request; import json; import subprocess; data = urllib.request.urlopen("https://dog.ceo/api/breeds/image/random").read(); url = json.loads(data)["message"]; subprocess.call(["curl", url, "-o", "dog.jpg"])\'',
          result: '',
        },

        {
          instruction: 'Read from stdin until EOF, and then output the length of the string',
          command: 'python3 -c \'import sys; print(len(sys.stdin.read().strip()))\'',
          result: '',
        },

        {
          instruction: 'Read a single line from stdin and pipe it to cowsay',
          command: 'python3 -c \'print(input())\' | cowsay',
          result: '',
        },

        {
          instruction: 'Run the fortune command 5 times',
          command: 'for i in {1..5}; do fortune; done',
          result: '',
        },
      ]
    end
  end
end
