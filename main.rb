#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# status = waiting, running, finished
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack'
require 'erb'
require 'json'
require 'yaml'
gem 'bson','1.0.4'
gem 'bson_ext','1.0.4'
gem 'mongoid','2.0.0.beta.16'
require 'mongoid'
require File.dirname(__FILE__)+'/models'

begin
  @@conf = YAML::load open(File.dirname(__FILE__) + '/config.yaml')
rescue
  STDERR.puts 'config.yaml load error'
  exit 1
end
p @@conf

before do
  dbname = @@conf['mongo_dbname']
  Mongoid.configure{|conf|
    conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(dbname)
  }
end

get '/find/:user_id' do
  user_id=params[:user_id]
  unless user_id
    status 403
    @mes {
      :error=>'"user_id" required'
    }.to_json
  else
    url=Page.limit(1).find_or_create_by(:user_id=>user_id)
    @mes = url.to_json
  end
end

post '/page' do
  url = params['url']
  user_id=params['user_id']
  unless url
    status 403
    @mes = {
      :error => '"url" required'
    }.to_json
  else
    page = Page.new(:url => url,:user_id => user_id)
    page.save
    @mes = {
      :url => url,
      :user_id => user_id
    }.to_json
  end
end

get '/page' do
  # 最後に見たページ
end
