class Card
  attr_reader :neighbour_name, :name, :min_touch, :min_block

  def initialize(neighbour_name, name, params = {})
    @neighbour_name = neighbour_name
    @name = name
    params.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def equipment?
    !!(min_touch && min_block)
  end
end