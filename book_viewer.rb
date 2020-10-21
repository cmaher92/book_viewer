require "sinatra"
require "sinatra/reloader"
require "tilt/erubis" # used for templating

before do
  # code here runs prior to routes making ivars available beforehand
  @contents = File.readlines('data/toc.txt')
end

get "/" do
  # File.read "public/template.html"
  @title    = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title    = "Chapter #{number}: #{chapter_name}"
  @chapter  = File.read("data/chp#{params['number']}.txt")

  erb :chapter
end
