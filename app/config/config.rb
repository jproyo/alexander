require 'rubygems'
require 'data_mapper'
require 'dm-migrations'
require 'sinatra/base'

# require all models
Dir.glob(File.join(File.dirname(__FILE__), "../model/*")).each do |model|
  require File.expand_path model
end

class Sinatra::Base

  configure :development do

    DataMapper::Logger.new($stdout, :debug)
    db_file = File.join(Dir.pwd, 'development_tmp.db')
    File.delete(db_file) if File.exists?(db_file)
    DataMapper.setup(:default, "sqlite://#{db_file}")
    DataMapper.auto_upgrade!
    DataMapper.finalize

  end

  configure :test do
    #DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, 'sqlite::memory:')
    DataMapper.auto_upgrade!
    DataMapper.finalize

    require "rspec"
    RSpec.configure do |config|
      config.before :each do 
        DataMapper.auto_migrate! 
      end
    end
    
  end

  configure :production do
    DataMapper::Logger.new($stdout, :info)
      DataMapper.setup(:default, {
        :adapter  => 'postgres',
        :host     => 'localhost',
        :username => 'skillhub' ,
        :password => 'skillhub',
        :database => 'skillhub'})
    DataMapper.auto_upgrade!
    DataMapper.finalize
  end
end
