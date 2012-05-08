require 'config/config'
require 'rack'
require 'api_controller'
require 'main_controller'

use Rack::Session::Cookie

map "/" do
  run Persons::Main
end

map "/api/" do
  run Persons::Api
end