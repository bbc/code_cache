$:<<'./lib'

require 'code_cache'
require 'code_cache/repo/git'
require 'code_cache/repo/svn'

GITHUB_SSH_URL = 'git@github.com:bbc-test/code_cache.git'
GITHUB_HTTPS_URL = 'https://github.com/bbc-test/code_cache.git'
GITHUB_SVN_URL = 'https://github.com/bbc-test/code_cache'

describe CodeCache do

  describe '.identify' do

    it 'identifies svn repo urls' do
      expect( CodeCache.identify(GITHUB_SVN_URL) ).to eq :svn
    end
    
    it 'identifies git repo urls' do
      expect( CodeCache.identify( GITHUB_SSH_URL ) ).to eq :git
      expect( CodeCache.identify( GITHUB_HTTPS_URL ) ).to eq :git
    end

  end
  
  describe '.repo' do
    
    it 'returns an svn repo object with an svn url' do
      expect( CodeCache.repo( GITHUB_SVN_URL ) ).to be_a CodeCache::Repo::SVN
    end
    
    it 'returns an git repo object with an git url' do
      expect( CodeCache.repo( GITHUB_SSH_URL ) ).to be_a CodeCache::Repo::Git
    end
    
  end

end
