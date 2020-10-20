require "sinatra"
require "sinatra/reloader"
require "tilt/erubis" # used for templating?
require 'pry'

get "/" do
  # File.read "public/template.html"
  @title    = "The Adventures of Sherlock Holmes"
  @contents = File.readlines('data/toc.txt').map(&:chomp)
  erb :home
end

get "/chapters/:number" do
  @title    = "Chapter #{params['number']}"
  @contents = File.readlines('data/toc.txt')
  @chapter  = File.read("data/chp#{params['number']}.txt")

  erb :chapter
end
