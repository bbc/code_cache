# code_cache
Version control checkout abstraction and cache.

## Usage

    repo =  CodeCache.repo( repo_url )
    begin
      repo.checkout( :head, 'path/to/checkout' )  # checkout master
      repo.checkout( :head, 'path/to/checkout', 'branch_name' )  # checkout specific branch
    rescue => e
      puts "Checkout failed"
    end

## Testing

Tests run against the github svn and git endpoints for this repository. Just run:

    bundle
    bundle exec rspec
    
## License

Code Cache is available to everyone under the terms of the MIT open source licence. Take a look at the LICENSE file in the code.

Copyright (c) 2015 BBC
