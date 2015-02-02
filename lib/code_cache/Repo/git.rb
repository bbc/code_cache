require 'code_cache/repo'

module CodeCache
  class Repo::Git < Repo
  
    def initialize(url, options = {})
      super(url, options)
    end
 
    # Split the url into a unique array for the cache path
    def split_url
      match = /(?:(?:git|ssh)@(.*):|(?:https?:\/\/(.*?)\/))(.*).git/.match(url)
      match.captures.compact
    end

    # Check access to the repo in question
    def check_repo(url)
      output = `git ls-remote #{url} 2>&1`
      if ($? != 0)
        raise BadRepo.new(url + "<<<" + output.to_s + ">>>")
      end
    end
    
    # Checkout a particular revision from the repo into the destination
    # Caches the checkout in the process
    def checkout( revision, destination )
      
      if revision != :head
        raise "Checking out anything other than the head of the default branch not supported"
      end
      
      cache_destination = location_in_cache()
      
      # Try and copy into the cache first
      clone_or_update_repo_in_cache(cache_destination)
      
      puts "Cache: #{cache_destination}"
      puts "Destination: #{destination}"
      
      checkout_from_cache_to_destination(cache_destination, destination, revision)
      
      true
    end
    
    def clone_or_update_repo_in_cache(cache_destination)
      update_result = update_cache(cache_destination)
      if update_result[:status] == true
        return true
      else
        clone_bare_repo_to_cache(cache_destination)
      end
    end
    
    def update_cache(cache_destination)
      output = `GIT_DIR=#{cache_destination} git fetch 2>&1`
      status = $? == 0
      { :output => output, :status => status }
    end
    
    def clone_bare_repo_to_cache(cache_destination)
      output = `git clone --bare #{url} #{cache_destination} 2>&1`
      status = $? == 0
      { :output => output, :status => status }
    end
    
    def checkout_from_cache_to_destination(cache_destination, destination, revision)
      output = `git clone --single-branch #{cache_destination} #{destination} 2>&1`
      status = $? == 0
      { :output => output, :status => status }
    end
    
  end
end