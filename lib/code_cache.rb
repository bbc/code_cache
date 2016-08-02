require 'code_cache/repo/git'
require 'code_cache/repo/svn'

module CodeCache

  def self.identify(url)
    if (url =~ /.*\.git\s*$/)
      :git
    else
      :svn
    end
  end
  
  def self.repo(url, options = {})
    if self.identify(url) == :git
      Repo::Git.new(url, options)
    else
      Repo::SVN.new(url, options)
    end
  end

end
