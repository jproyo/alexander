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

module SkillHub

  # Main Application Controller
  class Main < Sinatra::Base
    helpers Helpers
    register Sinatra::StaticAssets
    
    configure :production, :development do
      enable :logging
    end

    get '/' do
      erb :main
    end

    get '/persons' do
      erb :persons
    end

    get '/person/new' do
      erb  :person_new
    end

    post '/person' do
      logger.info params
      Person.create(params)
      erb :persons
    end

  end
end