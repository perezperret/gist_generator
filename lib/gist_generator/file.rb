require 'faraday'
require 'octokit'

module GistGenerator
  class File
    def initialize(repo_path, file_path, options)
      @repo_path = repo_path
      @file_path = file_path
      @options = options
    end

    def lines
      @lines ||= Faraday.get(content.download_url).body.lines
    end

    def number_of_lines
      lines.length
    end

    private

    attr_reader :file_path, :repo_path, :options

    def content
      client.contents repo_path, path: file_path, query: { ref: ref }
    end

    def ref
      commit ? commit.sha : 'master'
    end

    def commit
      @commit ||=
        if commit_message_regex
          commits.find { |c| c.commit.message.match? commit_message_regex }
        end
    end

    def commit_message_regex
      options[:commit_message_regex]
    end

    def commits
      @commits ||= client.commits(repo_path)
    end

    def client
      @client ||= Octokit::Client.new
    end
  end
end
