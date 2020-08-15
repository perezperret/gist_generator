# GistGenerator

Check out the [sample](https://github.com/perezperret/gist_generator_sample).

I built this project as a learning experience. Eventually I would like to write a series of tutorials for my [railsbyexample repos](https://github.com/railsbyexample) using this to generate the code sections within a static site. I wasn't able to find something similar.

This is still a test and I might change the API significantly in the future.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gist_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gist_generator

## Usage

You can build the gists with `GistGenerator::Generator.call`:

```ruby
  require 'gist_generator'

  GistGenerator::Generator.call([
    repo_path: 'username/package',
    gists: [
      {
        # path to the file you want to generate a gist for
        file_path: 'Gemfile',
        # line numbers (1-based), an array of ints or int ranges
        line_numbers: [1, 2, (8..10)],
        # A regex to select the version of the file by commit message, defaults to master
        commit_message_regex: /^Add activerecord/
      }
    ]
  ])
```

This will return an array of `Gist` objects, which expose:
- `Gist#lines` returns an array of the lines in the gist.
- `Gist#line_numbers` returns an array of the line numbers in the gist.
- `Gist#numbered_lines` returns a hash where the keys are the line numbers and the values are the contents of that line.

You can use the results directly and format them as you need them or use `GistGenerator::Serializers::Pretty` to convert them into a readable format. It accepts an array of `Gist` objects and an options hash. The only option currently supported is `line_separator` which is a string to denote trimmed lines:

```ruby
  source 'https://rubygems.org'
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  ruby '2.5.5'
  # ...

  # Use Puma as the app server
  gem 'puma', '~> 4.1'
  # Use SCSS for stylesheets
  # ...
```

The default line separator is for ruby (`# ...\n\n`).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/perezperret/gist_generator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
