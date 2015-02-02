# code_cache
Version control checkout abstraction and cache.

## Usage

    repo =  CodeCache.repo( repo_url )
    begin
      repo.checkout( :head, 'path/to/checkout' )
    rescue => e
      puts "Checkout failed"
    end

