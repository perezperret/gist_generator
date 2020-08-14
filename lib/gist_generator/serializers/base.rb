module GistGenerator
  module Serializers
    class Base
      def self.call(*args)
        new(*args).call
      end

      def initialize(gists)
        @gists = gists
      end

      def call
        gists.map do |gist|
          {
            'lines' => gist.lines,
            'numbered_lines' => gist.numbered_lines,
            'line_numbers' => gist.line_numbers
          }
        end
      end

      private

      attr_reader :gists
    end
  end
end
