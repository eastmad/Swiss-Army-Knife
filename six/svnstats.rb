require 'sinatra'
require_relative 'lib/helpers/developers_helper'

helpers DeveloperStatsHelper


before do
  @user_data = []

  Dir.entries(File.join(File.dirname(__FILE__),"userdata")).each do | f |
    
    #regex for name
    md = /user_(.*)@company.com/.match(f)

    @user_data << {:name => md[1], :file => f} unless md.nil?
  end
end

get '/' do
  "Hello from six"
end

get '/developers' do
  erb :developers
end

get '/developers/:name' do
  
  #get the name paramater
  name = params[:name]
  
  #Create filename
  @filename = "userdata/user_#{name}@company.com.html"

  #render
  erb :developer
end
