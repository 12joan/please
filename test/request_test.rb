# frozen_string_literal: true

require 'test_helper'

class RequestTest < Minitest::Test
  def test_initialize
    Please::Request.new(options: {}, instruction: 'Show my username')
  end
end
