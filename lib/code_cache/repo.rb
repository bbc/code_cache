require 'fileutils'

module CodeCache

  class Repo
    
    attr_accessor :url, :cache
    
    def initialize(url, options = {})
      @cache = options[:cache] || '/tmp/code_cache'
      @url = url
    end
    
    def create_cache(revision)
      if !Dir.exist? location_in_cache(revision)
        FileUtils.mkdir_p @cache
      end
    end
    
    def copy_from_cache
      
    end
  
  end

  class BadRepo < StandardError
  end

end