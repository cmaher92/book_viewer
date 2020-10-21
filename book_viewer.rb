require "sinatra"
require "sinatra/reloader"
require "tilt/erubis" # used for templating
require 'pry'

before do
  # code here runs prior to routes making ivars available beforehand
  @contents = File.readlines('data/toc.txt')
end

helpers do
  # This can be used directly in view templates (see views/chapter.erb)
  def in_paragraphs(content)
    content.split("\n\n").map.with_index do |paragraph, i|
      "<p id=#{i}>#{paragraph}</p>"
    end.join
  end

  def in_matched_paragraphs(paragraphs, ch_number)
    paragraphs = paragraphs.map do |paragraph|
      "<li>" + "<a href='/chapters/#{ch_number}##{paragraph[0]}'>#{paragraph[1]}</a>" + "</li>"
    end.join
    "<ul>#{paragraphs}</ul>"
  end
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt").split("\n\n")
    contents = contents.map.with_index do |par, index|
      [index, par]
    end
    yield number, name, contents
  end
end

def chapters_matching(str)
  results = []

  return results if !str || str.empty?

  each_chapter do |number, name, contents|
    contents.select! { |content| content[1].include?(str) }
    results << {number: number, name: name, contents: contents} unless contents.empty?
  end

  results
end

not_found do
  redirect '/'
end

get "/" do
  @title    = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search_form
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect '/' unless (1..@contents.size).cover? number

  @title    = "Chapter #{number}: #{chapter_name}"
  @chapter  = File.read("data/chp#{params['number']}.txt")
  erb :chapter
end
