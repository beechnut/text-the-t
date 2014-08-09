require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

require './models/user'

require 'geocoder'
# require 'mbta-realtime'

class TextBus < Sinatra::Base

  get '/' do
    @number = params[:From]
    @input  = params[:Body].split(" ")

    @user   = User.find(@number) || User.create(phone_number: @number,
                                                language:    'English',
                                                subscribed:   false,
                                                total_sent:   1       )

    session[:input]         = @input
    session[:current_user]  = @user

    stop_id = @input.shift
    routes  = @input.join(',')

    redirect to("/stop/#{stop_id}")
  end


  get '/stop/:stop_id' do
    params[:stop_id]
  end


  get '/address' do
    @input = session[:input]
    lat, lng = Geocoder.coordinates(@input)
  end

end