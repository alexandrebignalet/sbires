class Player
  PAWN_PER_PLAYER = 8
  INITIAL_POINT_NUMBER = 5

  attr_reader :name, :lord_name, :pawns, :points, :cards, :spare

  def initialize(name, lord_name)
    @name = name
    @lord_name = lord_name
    @points = INITIAL_POINT_NUMBER
    @pawns = (0...PAWN_PER_PLAYER).map { Pawn.new(@lord_name) }
    @cards = []
    @spare = []
  end

  def place_pawn_on(neighbour)
    raise Sbires::Error, "No more pawns to place" if all_pawns_placed?
    neighbour.receive_pawn_from(pawns.shift)
  end

  def pick_top_card_of_deck(neighbour)
    @cards << neighbour.shift_deck
  end

  def pick_card_in_discard(neighbour, card_name)
    card = neighbour.give_from_discard(card_name)
    @cards << card
  end

  def discard_in(card, neighbour)
    neighbour.add_discarded(card)
    @cards.delete card
  end

  def spare_card(card)
    @cards.delete card
    @spare << card
  end

  def all_pawns_placed?
    pawns.length == 0
  end

  def find_card(card_name)
    cards.detect { |c| c.name == card_name }
  end

  def == player
    lord_name == player.lord_name
  end
end