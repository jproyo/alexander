require 'fileutils'

module Alexander

	class AppBase
		
		def self.run(file_path)
			AppBase.send(ARGV[0].to_sym, ARGV[1], file_path)
		end

		def self.create(application, base_path)
			dest = File.join(base_path, application)
			Dir.mkdir(dest)
			src = File.expand_path(File.dirname(__FILE__) + "/templates")
			FileUtils.copy_entry(src, dest)
		end
	end
end