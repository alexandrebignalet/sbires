class PlayCards
  def initialize(game)
    @game = game
  end

  def draw_card(lord_name, card_name, play_params = {})
    player = @game.find_player lord_name
    card = player.find_card card_name

    @game.play_mediator.notify Play.new(@game, player, card, play_params)
  end

  def discard_spare_card(lord_name, card_name)
    player = @game.find_player lord_name
    card = player.find_card_in_spare card_name
    neighbour = @game.find_neighbour card.neighbour_name

    player.discard_spare_in(card, neighbour)
  end

  def place_pawn(lord_name, neighbour_name)
    raise_pawn_placement_over
  end

  def finish_first_phase
    raise_pawn_placement_over
  end

  private

  def raise_pawn_placement_over
    raise Sbires::Error, "Pawn placement phase is over"
  end
end