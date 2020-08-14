require "gist_generator/version"
require "gist_generator/gist"

module GistGenerator
  class Error < StandardError; end

  class Generator
    def self.call(*args)
      new(*args).call
    end

    def initialize(config)
      @repo_path = config.fetch(:repo_path)
      @gists_params = config.fetch(:gists)
    end

    def call
      gists_params.map do |params|
        Gist.new(params.merge(repo_path: repo_path))
      end
    end

    private

    attr_reader :gists_params, :repo_path
  end
end
