require 'rubygems'

class User
  include Mongoid::Document
  field :name, :default => ""
  field :created_at, :type => Integer, :default => Time.now.to_i
end

class Page
  include Mongoid::Document
  field :url
  field :user_id
  field :created_at, :type => Integer, :default => Time.now.to_i
end
