
require 'sinatra'

get '/' do
  "Hello from four"
end

get '/developers/:name' do
  
  #get the name paramater
  name = params[:name]
  
  #Create filename
  filename = "userdata/user_#{name}@company.com.html"

  #render
  File.read(File.join(File.dirname(__FILE__), filename))
  
end
