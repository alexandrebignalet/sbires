class Neighbour
  CARD_NUMBER_PER_NEIGHBOUR = 26

  attr_reader :name, :deck, :discard

  def initialize(name, players_in_game)
    @name = name
    @pawns = []
    @players_in_game = players_in_game
    @deck = (0...CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(@name) }
    @discard = []
  end

  def receive_pawn_from(pawn)
    raise Sbires::Error, "Neighbour is full" if full?
    @pawns << pawn
  end

  def shift_deck
    @deck.shift
  end

  def add_discarded(card)
    @discard << card
  end

  def dominant
    pawns_by_lord = @pawns.reduce({}) do |acc, curr|
      acc[curr.lord_name] = acc[curr.lord_name].nil? ? 1 : acc[curr.lord_name] + 1
      acc
    end
    pawns_number = pawns_by_lord.values
    max_pawns = pawns_number.max
    pawns_number.count(max_pawns) == 1 ? pawns_by_lord.detect { |k, v| v == max_pawns }.first : nil
  end

  def full?
    @pawns.length >= current_pawn_limit
  end

  private

  def current_pawn_limit
    pawn_limits = {
        Game::MIN_PLAYERS_IN_GAME => 4,
        3 => 5,
        4 => 7,
        Game::MAX_PLAYERS_IN_GAME => 8
    }

    pawn_limits[@players_in_game]
  end
end