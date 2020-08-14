require 'gist_generator/file'

module GistGenerator
  class Gist
    def initialize(params)
      @params = params
    end

    def lines
      return file.lines unless line_numbers

      line_numbers.map { |line| file.lines[line - 1] }
    end

    def line_numbers
      @line_numbers ||= parsed_line_numbers || all_line_numbers
    end

    def numbered_lines
      @numbered_lines ||= line_numbers.zip(lines).to_h
    end

    def file_number_of_lines
      file.number_of_lines
    end

    private

    attr_reader :params

    def file
      @file ||= File.new(params[:repo_path], params[:file_path], params)
    end

    def parsed_line_numbers
      params[:line_numbers]&.map { |n| Array(n) }&.flatten
    end

    def all_line_numbers
      Array(1..file.number_of_lines)
    end
  end
end
