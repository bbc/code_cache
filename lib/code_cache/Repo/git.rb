require 'code_cache/repo'

module CodeCache
  class Repo::Git < Repo
  
    def initialize(url)
      super(url)
    end
    
  end
end