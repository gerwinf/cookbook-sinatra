# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative 'models/cookbook'
require_relative 'models/recipe'
require_relative 'scraping_service'

get '/' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe = Recipe.new(name: params[:name],description: params[:description],prep_time: params[:prep_time],
  difficulty: params[:difficulty], url: params[:url])
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/recipes/:index' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

get '/cooked/:index' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  cookbook.mark_as_done(params[:index].to_i)
end

# new page to
get '/import' do
  erb :import
end

post '/imports' do
  # run scraper based on input from <form> in /import
  @matching_recipes = ScrapingService.new(params[:ingredient]).call
  # save to csv
  CSV.open('scrapped_results.csv', 'wb') do |csv|
    @matching_recipes.each do |k,v|
      csv << [k[:name], k[:description], k[:prep_time], k[:difficulty], k[:url], k[:done]]
    end
  end
  # display scraper results
  erb :imports
end

get '/imports/:index' do
  # users selects via index which to add
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  # load csv
  imported_recipes = []
  CSV.foreach('scrapped_results.csv') do |row|
    imported_recipes << Recipe.new(name: row[0], description: row[1], prep_time: row[2], difficulty: row[3], url: row[4], done: row[5]) #if params[:index]
  end
  # recipe = Recipe.new(row) where index matches
  cookbook.add_recipe(imported_recipes[params[:index].to_i])

  redirect to '/'
end

get '/importview' do
  erb :importview
end

get '/about' do
  erb :about
end
