# frozen_string_literal: true

require 'test_helper'

class PleaseTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Please::VERSION
  end
end
