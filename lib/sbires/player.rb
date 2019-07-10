class Player
  PAWN_PER_PLAYER = 8
  INITIAL_POINT_NUMBER = 5

  attr_reader :name, :lord_name, :pawns, :points, :cards

  def initialize(name, lord_name)
    @name = name
    @lord_name = lord_name
    @points = INITIAL_POINT_NUMBER
    @pawns = (0...PAWN_PER_PLAYER).map { Pawn.new(@lord_name) }
    @cards = []
  end

  def place_pawn_on(neighbour)
    raise Sbires::Error, "No more pawns to place" if all_pawns_placed?
    neighbour.receive_pawn_from(pawns.shift)
  end

  def pick_card_from(neighbour)
    @cards << neighbour.shift_deck
  end

  def discard_in(card, neighbour)
    raise Sbires::Error, "Not your card" unless cards.include? card

    neighbour.add_discarded(card)
    @cards.delete card
  end

  def all_pawns_placed?
    pawns.length == 0
  end
end