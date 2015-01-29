require 'code_cache/repo'

module CodeCache
  class Repo::Git < Repo
  
    def initialize(url, options = {})
      super(url, options)
    end
    
  end
end