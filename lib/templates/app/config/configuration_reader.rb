require 'yaml'
class ConfigurationReader
        attr_reader :crono_base_url, :crono_user, :crono_pass
        def initialize(configuration_path, profile_name)
                config = YAML.load_file(configuration_path)
                @crono_base_url = config[profile_name]['crono_base_url']
                @crono_user = config[profile_name]['crono_user']
                @crono_pass = config[profile_name]['crono_pass']
        end
end
