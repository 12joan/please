# frozen_string_literal: true

module Please
  Request = Struct.new(:options, :instruction, :codex_service, keyword_init: true) do
    def send
      codex_service.completion(<<~PROMPT.chomp).strip
        Write a one-line bash command each of the following tasks.

        # Print the current working directory
        $ pwd
        #{`pwd`}

        # Show information about the operating system
        $ uname -a
        #{`uname -a`}
      
        # List all files in the current directory
        $ ls -a
        #{`ls -a`}

        # #{instruction.gsub(/\n/, " ")}
        $
      PROMPT
    end
  end
end
