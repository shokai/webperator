require 'rubygems'

class User
  include Mongoid::Document
  field :user_id
  field :name
  field :created_at, :type => Integer
end

class Page
  include Mongoid::Document
  field :url
  field :user_id
  field :created_at, :type => Integer
end
