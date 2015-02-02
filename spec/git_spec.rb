require 'code_cache/repo'
require 'code_cache/repo/git'

GIT_URL = 'git@github.com:bbc-test/code_cache.git'
HTTPS_URL = 'https://github.com/bbc-test/code_cache.git'

CACHE_BASE = '/tmp/code_cache_tests_'

describe CodeCache::Repo::Git do
  
  describe '.new' do
    
    it 'creates a repo object' do
      repo = CodeCache::Repo::Git.new( GIT_URL )
      expect(repo).to be_a CodeCache::Repo::Git
    end  
    
    it "throws an exception if the repo url can't be hit" do
      expect{CodeCache::Repo::Git.new( GIT_URL + 'bad' )}.to raise_error(CodeCache::BadRepo)
    end
      
  end
  
  describe '#clone_repo_to_cache' do
    
    it 'clones a repository to the cache without a checkout' do

      cache = CACHE_BASE+rand(999999).to_s
      
      repo = CodeCache::Repo::Git.new( GIT_URL, :cache => cache )
      
      cache_destination = repo.location_in_cache()
      repo.clone_bare_repo_to_cache(cache_destination)
      
      expect( Dir.exist? cache_destination ).to eq true
      expect( Dir.exist? cache_destination+'/refs' ).to eq true
    end
    
  end
  
  describe '#checkout' do
    
    it 'checks out the head of the repo to cache and copies it to destination' do
      
      cache = CACHE_BASE+rand(999999).to_s
      
      repo = CodeCache::Repo::Git.new( GIT_URL, :cache => cache )
      
      destination = "/tmp/checkouts/#{rand(999999)}/code_cache"
      
      result = repo.checkout( :head, destination )
      
      expect( result ).to eq true
      
      cached_clone = cache + '/git/github.com/bbc-test/code_cache/'
      
      expect( Dir.exist?(cached_clone) ).to eq true
      expect( Dir.exist?(cached_clone + '/refs') ).to be true
      
      expect( Dir.exist?(destination) ).to eq true
      expect( Dir.exist?(destination+'/.git')).to eq true
      expect( File.exist?(destination + '/README.md') ).to be true
      
    end
    
    it 'checks out the same repo twice using the cache' do

      cache = CACHE_BASE+rand(999999).to_s
      repo = CodeCache::Repo::Git.new( GIT_URL, :cache => cache )
      
      destination_1 = "/tmp/checkouts/#{rand(999999)}/code_cache"
      destination_2 = destination_1 + '-second'
      
      t1 = Time.now
      result = repo.checkout( :head, destination_1 )
      t2 = Time.now
      result = repo.checkout( :head, destination_2 )
      t3 = Time.now
      
      puts "***************************"
      puts "First :  #{t2 - t1}"
      puts "Second:  #{t3 - t2}"
      puts "***************************"
      
      expect( t3 - t2 ).to be < t2 - t1
      
    end
    
  end
  
  describe '#create_cache' do
    
    it "creates full cache path if it doesn't already exist" do
      
      cache = CACHE_BASE+rand(999999).to_s
      `rm -rf #{cache}`
      
      repo = CodeCache::Repo::Git.new( GIT_URL, :cache => cache )
      
      repo.create_cache(:head)
      
      expect(Dir.exist?(cache)).to eq true
    end
    
  end
    
  describe '#location_in_cache' do
    
    it 'calculates the location of a checkout in the cache from an ssh url' do
      repo = CodeCache::Repo::Git.new( GIT_URL, :cache => '/tmp/cache' )
      expect(repo.location_in_cache(:head)).to eq '/tmp/cache/git/github.com/bbc-test/code_cache/head'
    end
    
    it 'calculates the location of a checkout in the cache from an https url' do
      repo = CodeCache::Repo::Git.new( HTTPS_URL, :cache => '/tmp/cache' )
      expect(repo.location_in_cache(:head)).to eq '/tmp/cache/git/github.com/bbc-test/code_cache/head'
    end
    
  end
  
end