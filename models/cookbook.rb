require 'csv'
require_relative 'recipe'

# csv_file = 'recipes.csv'

class Cookbook
  attr_accessor :recipes

  def initialize(csv_file)
    @recipes = []
    @csv_file = csv_file
    # CSV.open(csv_file) do |row|
    # @recipes << recipes #row
    # end
    load_csv
  end

  def mark_as_done(index)
    recipe = @recipes[index]
    recipe.mark_as_done!
    save_csv
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def all
    @recipes
  end

  def find(index)
    @recipes[index]
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      row[:done] = row[:done] == "true"
      @recipes << Recipe.new(row)
    end
  end

  def save_csv
    # @csv_file = csv_file
    CSV.open(@csv_file, 'wb') do |csv|
      csv << ["name", "description", "prep_time", "difficulty", "url", "done"]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.difficulty, recipe.url, recipe.done?]
      end
    end
  end
end
