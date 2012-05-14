require 'fileutils'

module Alexander
	class AppBase
		def self.create(application, base_path)
			dest = File.join(base_path, application)
			Dir.mkdir(dest)
			src = File.expand_path(File.dirname(__FILE__) + "/../app")
			FileUtils.cp_r(src, dest)
		end
	end
end