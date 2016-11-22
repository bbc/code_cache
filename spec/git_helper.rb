module GitHelpers
  def remote_git_repo(name, options = {})
    pwd = `pwd`.strip
    path = File.join("#{pwd}/spec/tmp/git_remotes", name)
    remote_url = "file://#{path}"

    FileUtils.mkdir_p(path)

    Dir.chdir(path) do
      git %|init --bare|
      git %|config core.sharedrepository 1|
      git %|config receive.denyNonFastforwards true|
      git %|config receive.denyCurrentBranch ignore|
    end

    Dir.chdir(git_scratch) do
      # Create a bogus file
      File.open('file', 'w') { |f| f.write('hello') }

      git %|init .|
      git %|add .|
      git %|commit -am "Initial commit for #{name}..."|
      git %|remote add origin "#{remote_url}"|
      git %|push origin master|

      options[:tags].each do |tag|
        File.open('tag', 'w') { |f| f.write(tag) }
        git %|add tag|
        git %|commit -am "Create tag #{tag}"|
        git %|tag "#{tag}"|
        git %|push origin "#{tag}"|
      end if options[:tags]

      options[:branches].each do |branch|
        
        git %|checkout -b #{branch} master|
        File.open('branch', 'w') { |f| f.write(branch) }
        git %|add branch|
        git %|commit -am "Create branch #{branch}"|
        git %|push origin "#{branch}"|
        git %|checkout master|
      end if options[:branches]
    end

    path
  end
  
  def git_scratch
        path = File.join(File.expand_path("../../tmp", __FILE__), "git", "scratch")
        FileUtils.mkdir_p(path) unless File.directory?(path)
        path
  end

  def git(command)
     shellout!("git #{command}")
  end

  def shellout!(command, options = {})
     cmd = Mixlib::ShellOut.new(command, options)
     cmd.environment["HOME"] = "/tmp" unless ENV["HOME"]
     cmd.run_command
     cmd
  end
end

RSpec.configure do |config|
  config.include(GitHelpers)
end

