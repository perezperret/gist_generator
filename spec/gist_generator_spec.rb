RSpec.describe GistGenerator::Generator do
  before do
    stub_commits_request('test_username/test_repo') do
      [
        { sha: 'test_commit_sha_1', commit: { message: 'commit_message_1' } },
        { sha: 'test_commit_sha_2', commit: { message: 'commit_message_2' } }
      ]
    end

    stub_contents_request(
      'test_username/test_repo', 'test_file', ref: 'master'
    ) do
      { download_url: 'https://api.github.com/content/test_file_2' }
    end

    stub_download_request('https://api.github.com/content/test_file_2') do
      Fixtures::MASTER_GEMFILE.join
    end
  end

  it 'generates gist data for a full file' do
    config =
      {
        repo_path: 'test_username/test_repo',
        gists: [{ file_path: 'test_file' }]
      }

    result = described_class.call(config)
    expect(result.first.lines).to eq(Fixtures::MASTER_GEMFILE)
  end

  it 'generates gist data for a specific line' do
    config =
      {
        repo_path: 'test_username/test_repo',
        gists: [{ file_path: 'test_file', line_numbers: [3] }]
      }

    result = described_class.call(config)
    expect(result.first.lines).to eq([Fixtures::MASTER_GEMFILE[2]])
  end

  it 'generates gist data for a few lines' do
    config =
      {
        repo_path: 'test_username/test_repo',
        gists: [{ file_path: 'test_file', line_numbers: [3, 8, 9] }]
      }

    result = described_class.call(config)
    expect(result.first.lines)
      .to eq(
        Fixtures::MASTER_GEMFILE.yield_self do |lines|
          [lines[2], lines[7], lines[8]]
        end
      )
  end

  it 'generates gist data for a range of lines' do
    config =
      {
        repo_path: 'test_username/test_repo',
        gists: [{ file_path: 'test_file', line_numbers: [(8..10)] }]
      }

    result = described_class.call(config)
    expect(result.first.lines)
      .to eq(
        Fixtures::MASTER_GEMFILE.yield_self do |lines|
          [lines[7], lines[8], lines[9]]
        end
      )
  end

  it 'generates gist data for a specific commit message regex' do
    config =
      {
        repo_path: 'test_username/test_repo',
        gists: [{
          file_path: 'test_file', line_numbers: [1],
          commit_message_regex: /message_1$/
        }]
      }

    stub_contents_request(
      'test_username/test_repo', 'test_file', ref: 'test_commit_sha_1'
    ) do
      { download_url: 'https://api.github.com/content/test_file_1' }
    end

    stub_download_request('https://api.github.com/content/test_file_1') do
      Fixtures::MASTER_ROUTES.join
    end

    result = described_class.call(config)
    expect(result.first.lines)
      .to eq([Fixtures::MASTER_ROUTES[0]])
  end

  GITHUB_API_URL = 'https://api.github.com/repos'.freeze

  def stub_commits_request(repo_path)
    stub_request(
      :get,
      [GITHUB_API_URL, repo_path, 'commits'].join('/')
    )
      .to_return(
        body: yield.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def stub_contents_request(repo_path, file_path, ref: nil)
    stub_request(
      :get,
      [
        GITHUB_API_URL, repo_path, 'contents', file_path
      ].join('/') + "?ref=#{ref}"
    )
      .to_return(
        body: yield.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def stub_download_request(file_url)
    stub_request(:get, file_url).to_return(body: yield)
  end
end
