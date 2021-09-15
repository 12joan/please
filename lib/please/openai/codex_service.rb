# frozen_string_literal: true

require 'ruby/openai'

module Please
  module OpenAI
    CodexService = Struct.new(:access_token, keyword_init: true) do
      def completion(prompt)
        client = ::OpenAI::Client.new(access_token: access_token)

        response = client.completions(
          engine: 'davinci-codex',
          parameters: default_parameters.merge(
            prompt: prompt,
          ),
        )

        response.parsed_response.fetch('choices').first.fetch('text')
      end

      private

      def default_parameters
        {
          temperature: 0,
          max_tokens: 300,
          top_p: 1,
          frequency_penalty: 0,
          presence_penalty: 0,
          stop: ["\n\n"],
        }
      end
    end
  end
end
