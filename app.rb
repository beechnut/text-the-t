require "rubygems"
require "sinatra/base"

class TextBus < Sinatra::Base

  get '/' do
    'This will be a text someday'
  end

end