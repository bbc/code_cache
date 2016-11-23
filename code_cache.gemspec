Gem::Specification.new do |s|
  s.name        = 'code_cache'
  s.version     = '0.2.1'
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.licenses    = ['MIT']
  s.summary     = "Abstracts & caches svn & git operations"
  s.description = "Provides a simple api for checking out svn and git repositories. Caches checkouts locally so that subsequent checkouts are optimised."
  s.authors     = ["David Buckhurst"]
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = ["lib/code_cache.rb","lib/code_cache/repo.rb","lib/code_cache/repo/git.rb","lib/code_cache/repo/svn.rb","README.md"]
  s.homepage    = 'https://github.com/bbc/code_cache'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'mixlib-shellout', '~> 2.2.7'
end
