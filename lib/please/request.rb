# frozen_string_literal: true

module Please
  Request = Struct.new(:instruction, :codex_service, :context, keyword_init: true) do
    def send
      codex_service.completion(prompt)
        .strip
        # Collapse multiline commands into one line
        .gsub(/\s*\\\n\s*/, ' ')
        # Remove subsequent lines that do not contain commands
        .gsub(/\n[^$][^\n]*$/, '')
        # Collapse multiple commands into one line
        .gsub(/\n\$ /, '; ')
        # Remove multiple consecutive spaces
        .gsub(/\s+/, ' ')
    end

    def prompt
      <<~PROMPT.chomp
        Write a one-line bash command for each of the following tasks.

        #{context}

        # #{instruction.gsub(/\n/, " ")}
        $
      PROMPT
    end
  end
end
