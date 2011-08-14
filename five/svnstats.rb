
require 'sinatra'

before do
  @user_data = []

  Dir.entries(File.join(File.dirname(__FILE__),"userdata")).each do | f |
    
    #regex for name
    md = /user_(.*)@company.com/.match(f)

    @user_data << {:name => md[1], :file => f} unless md.nil?
  end
end

get '/' do
  "Hello from five"
end

get '/developers' do
  erb :developers
end

get '/developers/:name' do
  
  #get the name paramater
  name = params[:name]
  
  #Create filename
  filename = "userdata/user_#{name}@company.com.html"

  #render
  File.read(File.join(File.dirname(__FILE__), filename))
  
end
