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

# get user's last URL
get '/find/:user_id' do
  user_id=params[:user_id]
  if user_id==''
    status 403
    @mes = {
      :error => '"user_id" required'
    }.to_json
  else
    url=Page.limit(1).find_or_create_by(:user_id=>user_id)
    @mes = url.to_json
  end
end

# persist user account
post '/register' do
  user_id=params['user_id']
  password=params['password']
  name=params['name']

  if((user_id=='') or (password=='') or (name==''))
    @mes = {
      :error => '"user_id" or "password" or "name" required'
    }.to_json
  else
    now_time=Time.now.to_i
    user=User.new(:user_id=>user_id,:password=>password,:name=>name,:created_at=>now_time)
    user.save
    @mes = {
      :result => 'success',
      :user_id => user_id,
      :name => name,
      :password => password,
      :created_at => now_time
    }.to_json
  end
end

# persist URL info
post '/page' do
  url = params['url']
  user_id=params['user_id']
  if((url=='') or (user_id==''))
    status 403
    @mes = {
      :error => '"url" or "user_id" required'
    }.to_json
  else
    now_time=Time.now.to_i
    page = Page.new(:url => url,:user_id => user_id, :created_at => now_time)
    page.save
    @mes = {
      :url => url,
      :user_id => user_id,
      :created_at => now_time
    }.to_json
  end
end

get '/user/:user_id' do
  user_id=params[:user_id]
  erb :tv,:locals => {:hoge => 'hogehiko',:user_id => user_id}
end

# get user's playlist
get '/playlist/:user_id' do
  user_id=params[:user_id]
  if(user_id=='')
    status 403
    @mes = {
      :error => '"user_id" required'
    }.to_json
  else 
    #(:all, :conditions => { :first_name => "Syd" })
    Page.desc(:created_at)
    result=Page.all(:conditions=>{:user_id=>user_id})
    @mes = result.to_json
  end
end
