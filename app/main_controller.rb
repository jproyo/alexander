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
      erb  :person_new, :locals => {:person => Person.new}
    end

    get '/person/update/:id' do |id|
      erb  :person_new, :locals => {:person => Person.get(id)}
    end

    post '/person' do
      logger.info params
      person = Person.get(params[:user_name])
      Person.create(params) if not person
      person.update(params) if person
      erb :persons
    end

  end
end