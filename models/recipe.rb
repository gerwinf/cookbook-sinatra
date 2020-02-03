class Recipe
  attr_reader :name, :description, :prep_time, :difficulty, :url
  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @difficulty = attributes[:difficulty]
    @url = attributes[:url]
    @done = attributes[:done] || false
  end

  def done? # better than attr reader beacause .method convetion
    @done
  end

  def mark_as_done!
    @done = true
  end
end
