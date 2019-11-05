class Neighbour
  CARD_NUMBER_PER_NEIGHBOUR = 26

  attr_reader :name, :deck, :discard

  def initialize(name, players_in_game, deck_factory = DeckFactory.new)
    @name = name
    @pawns = []
    @players_in_game = players_in_game
    @deck = deck_factory.create_deck_for name
    @discard = []
  end

  def receive_pawn_from(pawns)
    raise Sbires::Error, "Neighbour #{@name} is full" if full?
    @pawns << pawns.shift
  end

  def give_from_discard(card_name)
    card = @discard.detect { |card| card.name == card_name }
    raise Sbires::Error, "Card not in discard" if card.nil?

    @discard.delete(card)
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