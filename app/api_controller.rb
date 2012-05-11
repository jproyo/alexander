require 'sinatra/base'
require 'json'

module Persons

  # Api Controller
  class Api < Sinatra::Base

    configure :production, :development do
      enable :logging
    end

    before do
      content_type :json
    end

    get '/persons' do
      Person.all(:order => [:user_name.asc]).to_json
    end

    get '/persons/:id' do |id|
      Person.get(id).to_json
    end    

    delete '/persons/:id' do |id|
      Person.delete(id)
      200
    end    

    get '/person/new' do
      Person.new.to_json
    end

    put '/persons/:id' do |id|
      data = JSON.parse(request.body.read)
      data.delete("id")
      logger.info data
      person = Person.get(id)
      person.update(data) if person
      Person.create(data) if not person
      200
    end

  end
end