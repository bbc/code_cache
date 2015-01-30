require 'code_cache/repo'

module CodeCache
  class Repo::SVN < Repo
  
    def initialize(url, options = {})
      super(url, options)
      
      check_repo(url)
    end
    
    def checkout( revision, destination )
      
      if revision != :head
        raise "Checking out revisions other than head currently not supported"
      end
      
      cache_destination = location_in_cache(revision)
      
      # Try and copy into the cache first
      begin
        perform_cache_checkout_or_update(cache_destination)
        FileUtils.mkdir_p(destination)
        
        FileUtils.cp_r(cache_destination+'/.', destination)
        # Ensure the final copy is consistent
        raise CopyError if !Dir.exist?(destination)
        output = perform_update(destination)
        if !output[:status]
          raise UpdateError.new(output)
        end
        
      rescue => e
        puts "Unhandled randomness: " + e.to_s + ' - ' + e.backtrace.to_s
        # If we can't copy into the cache, copy directly to the destination
        perform_checkout(destination)
      end
      
      true
    end
    
    def perform_cache_checkout_or_update(destination, attempts = 3)
      update_result = perform_update(destination)
      if update_result[:status] == true
        return true
      else
        checkout_result = perform_checkout(destination)
        if checkout_result[:status]
          return true
        else
          # Cache update in progress, retry with some sleeps
          if checkout_result[:output] =~ /E155037/
            sleep 1
            if attempts > 0
              perform_cache_checkout_or_update( destination, attempts-1 )
            else
              return false
            end
 
          # Cache has become corrupted
          elsif checkout_result[:output] =~ /E155004/  
            raise CacheCorruptionError.new(url)
          else
            raise UnknownCheckoutError.new(url)
          end
        end
      end
    end

    # Perform an svn update on a directory -- checks its a valid svn dir first
    def perform_update(destination)
      output = `svn info #{destination} 2>&1 && svn up #{destination} 2>&1`
      status = $? == 0
      { :output => output, :status => status }
    end
    
    def perform_checkout(destination)
      output = `svn co #{url} #{destination} 2>&1`
      status = $? == 0
      { :output => output, :status => status }
    end
    
    # Check access to the repo in question
    def check_repo(url)
      output = `svn ls #{url} 2>&1`
      if ($? != 0)
        raise BadRepo.new(url + "<<<" + output.to_s + ">>>")
      end
    end
   
    
    # Calculates the location of a cached checkout
    def location_in_cache( revision )
      File.join( cache, 'svn', split_url, revision.to_s )
    end
    
    def split_url
      url.split('//').drop(1).collect{ |e| e.split('/') }.flatten
    end
  end
  
  class UnknownCheckoutError < StandardError
  end
  
  class CacheCorrupionError < StandardError
  end
  
  class UpdateError < StandardError
  end
  
  class CopyError < StandardError
  end
  
end