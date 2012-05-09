require 'sinatra/base'
require 'sinatra/static_assets'
module Helpers

  def show_scripts
    @scripts.inject(""){ |s,element| s + "#{javascript_script_tag(element)}\n"} if (@scripts)
  end

  def show_styles
    @styles.inject(""){ |s,element| s + "#{stylesheet_link_tag(element)}\n"} if (@styles)
  end

end

module Persons

  # Main Application Controller
  class Main < Sinatra::Base
    helpers Helpers
    register Sinatra::StaticAssets
    
    set :public_folder, File.dirname(__FILE__) + '/public/static'    
    
    configure :production, :development do
      enable :logging
    end

    get '/' do
      erb :main
    end

    get '/persons' do
      erb :persons
    end

  end
end