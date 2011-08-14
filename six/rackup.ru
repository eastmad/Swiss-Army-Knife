require 'rubygems'
require "bundler"
Bundler.setup
require 'sinatra'

#set :env,      ":svnstats-dev"
#set :port,     4567

disable :run, :reload

$: << '.' 
require "svnstats"

run Sinatra::Application
