require 'gist_generator/serializers/base'

module GistGenerator
  module Serializers
    class Pretty
      def self.call(*args)
        new(*args).call
      end

      def initialize(gists, options = {})
        @gists = gists
        @options = options
      end

      def call
        gists.map { |gist| pretty_print gist }
      end

      private

      attr_reader :gists, :options

      def pretty_print(gist)
        result = []

        result << line_separator if gist.line_numbers.first != 1

        gist.line_numbers.each.with_index do |line_number, i|
          result << gist.numbered_lines[line_number]
          result << line_separator if needs_separator?(line_number, i, gist)
        end

        result << line_separator if gist.line_numbers.last != gist.file_number_of_lines

        result
      end

      def line_separator
        options.fetch(:line_separator, "# ...\n\n")
      end

      def needs_separator?(line_number, index, gist)
        line_number < (gist.line_numbers[index + 1] || gist.line_numbers.last) - 1
      end
    end
  end
end
