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

    @user = User.find_or_create_by(phone_number: @number)
    puts "valid: #{@user.valid?}"
    puts "errs: #{@user.errors.full_messages}"
    puts "user: #{@user.inspect}"

    session[:input] = @input

    stop_id, routes = @input.shift, @input.join(',')

    redirect to("/stop/#{stop_id}?routes=#{routes}") if routes
    redirect to("/stop/#{stop_id}")
  end

  get '/stop/:stop_id' do
    "stop: #{params[:stop_id]},\nroutes: #{params[:routes]}"
  end


  get '/address' do
    @input = session[:input]
    lat, lng = Geocoder.coordinates(@input)
  end

end