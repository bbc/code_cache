Gem::Specification.new do |s|
  s.name        = 'code_cache'
  s.version     = '0.1.3'
  s.licenses    = ['MIT']
  s.summary     = "Abstracts & caches svn & git operations"
  s.description = "Provides a simple api for checking out svn and git repositories. Caches checkouts locally so that subsequent checkouts are optimised."
  s.authors     = ["David Buckhurst"]
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = ["lib/code_cache.rb","lib/code_cache/repo.rb","lib/code_cache/repo/git.rb","lib/code_cache/repo/svn.rb"]
  s.homepage    = 'https://github.com/bbc-test/code_cache'
end
