class BagarreGeneraleState < PlayCards
  attr_reader :discardable_opponents

  def initialize(game)
    super(game)
    @discarded_opponents = []
    @discardable_opponents = find_discardable_opponent
  end

  def discard_spare_card(lord_name, card_name)
    super(lord_name, card_name)
    @discarded_opponents << lord_name

    @game.end_turn
    @game.transition_to(PlayCards) if all_opponent_discarded?
  end

  private

  def all_opponent_discarded?
    @discardable_opponents.all? { |discardable| @discarded_opponents.include?(discardable) }
  end

  def find_discardable_opponent
    current_player = @game.current_player
    opponent_with_spare_cards = @game.players.select { |p| p.spare.length > 0 && p != current_player }
    opponent_with_spare_cards.map(&:lord_name)
  end
end