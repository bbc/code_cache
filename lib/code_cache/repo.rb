require 'fileutils'
require 'rbconfig'
require 'tmpdir'

module CodeCache

  class Repo
    
    attr_accessor :url, :cache
    
    def initialize(url, options = {})
      cache_dir = Dir.tmpdir() if RbConfig::CONFIG['host_os'].include? "ming" 
      @cache = options[:cache] || cache_dir || '/tmp/code_cache'
      @url = url
      
      check_repo(url)
    end
    
    def create_cache(revision)
      if !Dir.exist? location_in_cache(revision)
        FileUtils.mkdir_p @cache
      end
    end
    
    # Calculates the location of a cached checkout
    def location_in_cache( revision = nil )
      begin
        elements = [cache, repo_type, split_url, revision].flatten.compact.collect { |i| i.to_s } 
        File.join( elements )
      rescue => e
        raise CacheCalculationError.new(e.msg + e.backtrace.to_s)
      end
    end
    
    def repo_type
      self.class.to_s.split('::').last.downcase
    end
  
  end

  class BadRepo < StandardError
  end
  
  class UnknownCheckoutError < StandardError
  end
  
  class CacheCalculationError < StandardError
  end
  
  class CacheCorruptionError < StandardError
  end
  
  class UpdateError < StandardError
  end
  
  class CopyError < StandardError
  end

end
