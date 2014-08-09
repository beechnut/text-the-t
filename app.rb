require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

require './models/user'

class TextBus < Sinatra::Base

  get '/' do
    'This will be a text someday'
  end

end