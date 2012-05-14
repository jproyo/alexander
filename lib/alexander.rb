require 'fileutils'
require 'thor'

module Alexander

	class AppBase < Thor

		desc "create", "Create a new Alexander application"
		
		def create(application)
			dest = File.join(File.expand_path("."), application)
			Dir.mkdir(dest)
			src = File.expand_path(File.dirname(__FILE__) + "/templates")
			FileUtils.copy_entry(src, dest)
		end
	end
end