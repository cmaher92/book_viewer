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
    content.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end

  def each_chapter
    @contents.each_with_index do |name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      yield number, name, contents
    end
  end

  def chapters_matching(str)
    results = []

    return results if !str || str.empty?

    each_chapter do |number, name, contents|
      results << {number: number, name: name} if contents.include?(str)
    end

    results
  end
end

not_found do
  redirect '/'
end

get "/" do
  @title    = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/search" do
  # Now, add some code to the new route that checks if any of the chapters
  # contain whatever text is entered into the search form. Render a list of
  # links to the matching chapters in the template.

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
