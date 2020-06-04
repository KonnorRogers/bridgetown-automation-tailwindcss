# frozen_string_literal: true

require 'stringio'

module TailwindCss
  module IoTestHelpers
    def simulate_stdin(*inputs)
      io = StringIO.new
      inputs.flatten.each { |str| io.puts(str) }
      io.rewind

      actual_stdin = $stdin
      $stdin = io
      yield
    ensure
      $stdin = actual_stdin
    end
  end
end
