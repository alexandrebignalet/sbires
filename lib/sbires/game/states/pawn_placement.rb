class PawnPlacement
  def initialize(game)
    @game = game
  end

  def place_pawn(lord_name, neighbour_name)
    player = @game.find_player(lord_name)
    raise Sbires::Error, "Not your turn" unless player == @game.current_player

    neighbour = @game.find_neighbour neighbour_name

    player.place_pawn_on neighbour
    player.pick_top_card_of_deck neighbour

    finish_first_phase if @game.first_phase_over?

    @game.end_turn
  end

  def end_turn; end

  def finish_first_phase
    @game.neighbours.each do |neighbour|
      next unless neighbour.dominant

      dominant = @game.find_player neighbour.dominant
      dominant.pick_top_card_of_deck neighbour
    end

    @game.transition_to PlayCards.new(@game)
  end

  def draw_card(lord_name, card_name, play_params)
    raise Sbires::Error, "Not in phase Play Cards"
  end

  def discard_spare_card(lord_name, card_name)
    raise Sbires::Error, "Not in phase Play Cards"
  end
end