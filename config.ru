require 'rubygems'
require 'sinatra'
require 'rack'
require 'main'

set :environment, :production

run Sinatra::Application
