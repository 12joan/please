# frozen_string_literal: true

module Please
  Request = Struct.new(:options, :instruction, :codex_service, keyword_init: true) do
    def send
      codex_service.completion(<<~PROMPT.chomp).strip
        Write a one-line bash command each of the following tasks.

        # Print the current working directory
        $ pwd

        # #{instruction.gsub(/\n/, " ")}
        $
      PROMPT
    end
  end
end
