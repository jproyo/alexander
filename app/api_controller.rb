require 'sinatra/base'
require 'json'

module Persons

  # Api Controller
  class Api < Sinatra::Base

    def json_to_skill_levels(levels)
      levels.collect do |level|
        SkillLevel.create(
          :description => level['description'],
          :name => level['name'], ##TODO is ok that the user specifies the name?
          :index => level['index'])
      end  
    end 

    configure :production, :development do
      enable :logging
    end

    before do
      content_type :json
    end

    get '/persons' do
      Person.all(:order => [:user_name.asc]).to_json
    end

  end
end