require 'json'
require 'gist_generator/serializers/base'

module GistGenerator
  module Serializers
    class JSON < Base
      def self.call(*args)
        new(*args).call
      end

      def initialize(gists)
        @gists = gists
      end

      def call
        { 'gists' => super.to_json }
      end

      private

      attr_reader :gists
    end
  end
end
