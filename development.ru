require 'rubygems'
require 'sinatra'
require 'rack'
require 'main'

set :environment, :development

set :port, 8888
set :server, 'thin'

Sinatra::Application.run
