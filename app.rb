require 'dotenv'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'

require './models/user'

require 'mbta-realtime'

class TextBus < Sinatra::Base

  Dotenv.load
  @@mbta = MBTARealtime::Client.new(api_key: ENV['MBTA'])

  enable :sessions
  enable :partial_underscores

  get '/' do
    @number = params[:From]
    @input  = params[:Body]

    @user = User.find_or_create_by(phone_number: @number)
    @user.update_attribute(:total_sent, @user.total_sent += 1)

    session[:input] = @input
    session[:user]  = @user
    
    redirect to ("save/#{$1}") if @input.match /^\s*save\s{1}(\d+)$/i
    redirect to ("/stops")     if @input.match /^\s*stops\s*$/i
    redirect to ("/count")     if @input.match /^\s*count\s*$/i
    
    # Send request to /address for geocoding and searching
    redirect to("/address?address=#{@input}") if mostly_text(@input)

    @input          = @input.split(" ")
    stop_id, routes = @input.shift, @input.join(',')

    redirect to("/stop/#{stop_id}?routes=#{routes}") if routes
    redirect to("/stop/#{stop_id}")
  end


  get '/stop/:stop_id' do
    stop_id = params[:stop_id]
    @stop   = OpenStruct.new({id:   stop_id,
                              name: @@mbta.stop_name(stop_id)})
    @routes = Array(params[:routes]).split(',')

    begin
      @predictions = @@mbta.flat_complex_predictions(@stop.id, @routes)
    rescue NoMethodError
      redirect to("/no-match")
    end
    @time   = Time.now.strftime("%I:%M %P")

    haml :"predictions/all"
  end


  get '/address' do
    puts "address: #{params[:address]}"
    begin
      stop_id = @@mbta.nearest_stop_id_by_location_name(params[:address])
    rescue NoMethodError
      redirect to("/no-match")
    end
    
    redirect to("/stop/#{stop_id}")
  end


  get "/stops" do
    @user  = session[:user] || User.first
    @stops = @user.saved_stops

    if @stops.empty?
      haml :no_stops
    else
      @stops = @stops.map {|s| OpenStruct.new(id: s, name: @@mbta.stop_name(s)) }
      haml :user_stops
    end
  end


  get "/save/:stop_id" do
    @user = session[:user] || User.first
    @stop = OpenStruct.new({id:   params[:stop_id],
                            name: @@mbta.stop_name(params[:stop_id]) })

    @user.saved_stops = @user.saved_stops + [ @stop.id ]
    if @user.save
      haml :save_success
    else
      redirct to('/no-match')
    end
  end


  get "/count" do
    @user = session[:user] || User.first
    haml "You have sent #{@user.total_sent} messages to TextBus."
  end


  get '/no-match' do
    "Sorry, we couldn't find that stop."
  end

  error 500 do
    haml :"500"
  end

  error 404 do
    haml :"404"
  end


  private

    def mostly_numbers(string)
      is_digit = /^\d{1}$/
      arr = string.split('')
      arr.count {|e| e.match is_digit } / arr.length.to_f > 0.6
    end


    def mostly_text(string)
      !mostly_numbers(string)
    end

end