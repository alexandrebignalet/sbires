class Card
  attr_reader :neighbour_name, :name

  def initialize(neighbour_name, name)
    @neighbour_name = neighbour_name
    @name = name
  end
end