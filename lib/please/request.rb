# frozen_string_literal: true

module Please
  Request = Struct.new(:options, :instruction, keyword_init: true) do
    def send!
      yield 'whoami'
    end
  end
end
