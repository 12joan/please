# frozen_string_literal: true

require 'test_helper'

class RequestTest < Minitest::Test
  def setup
    @codex_service = Class.new do
      def completion(prompt)
        @completion_response || "Completion for `#{prompt}`"
      end
    end.new
  end

  def test_send
    command = request(instruction: 'Find all files with names starting with Q').send
    assert_match 'Find all files with names starting with Q', command
  end

  private

  def request(options = {})
    Please::Request.new({
      options: {},
      instruction: 'Show my username',
      codex_service: @codex_service,
    }.merge(options))
  end
end
