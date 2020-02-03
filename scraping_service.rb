require 'nokogiri'
require 'open-uri'

# ingredient = x #from view
# url = "https://www.bbcgoodfood.com/search/recipes?query=#{ingredient}"
# doc = Nokogiri::HTML(open(url), nil, 'utf-8')

class ScrapingService
  def initialize(ingredient)
    @ingredient = ingredient
    @results = []
  end

  def call
    url = open("https://www.bbcgoodfood.com/search/recipes?query=#{@ingredient}").read
    doc = Nokogiri::HTML(url)
    doc.search('.node-recipe').each do |element|
      @results << {
        name: element.search('.teaser-item__title').text.strip,
        description: element.search('.field-item').text.strip,
        prep_time: element.search('.teaser-item__info-item--total-time').text.strip,
        difficulty: element.search('.teaser-item__info-item--skill-level').text.strip,
        url: "https://www.bbcgoodfood.com" + element.search('.teaser-item__title a').attribute('href').value
      }
    end
    @results
  end
end
