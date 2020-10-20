require "sinatra"
require "sinatra/reloader"
require "tilt/erubis" # used for templating?

get "/" do
  # File.read "public/template.html"
  @title    = "The Adventures of Sherlock Holmes"
  @contents = File.readlines('data/toc.txt').map(&:chomp)
  erb :home
end

get "/chapters/1" do
  @title    = "Chapter 1"
  @contents = File.readlines('data/toc.txt')
  @chapter  = File.read('data/chp1.txt')

  erb :chapter
end
