# frozen_string_literal: true

require 'test_helper'

class RequestTest < Minitest::Test
  def test_prompt
    prompt = request(
      instruction: 'Find all files with names starting with Q',
      context: 'I\'m a context!',
    ).prompt

    assert_match 'Find all files with names starting with Q', prompt
    assert_match 'I\'m a context!', prompt
  end

  def test_send
    @completion_response = <<~RESPONSE
      do one thing \
        --with \
        --multiline-commands
      erroneous output
      $ do another thing
    RESPONSE

    command = request.send

    assert_equal <<~COMMAND.strip, command
      do one thing --with --multiline-commands; do another thing
    COMMAND
  end

  private

  def codex_service
    Struct.new(:completion_response) do
      def completion(prompt)
        completion_response || "Completion for `#{prompt}`"
      end
    end.new(@completion_response)
  end

  def request(options = {})
    Please::Request.new({
      instruction: 'Show my username',
      context: 'This is some context',
      codex_service: codex_service,
    }.merge(options))
  end
end
