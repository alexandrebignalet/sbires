module PlayHandlers
  class Fossoyeur
    def run(play)
      current_player = play.game.current_player
      raise Sbires::Error, "Not your turn" unless play.submitter == current_player

      neighbour = play.game.find_neighbour(play.params[:neighbour_discard])
      raise Sbires::Error, "Unknown neighbour" if neighbour.nil?

      current_player.pick_card_in_discard(neighbour, play.params[:chosen_card_name])

      play.game.end_turn
    end

    def listen_to(card)
      [CardType::FOSSOYEUR].include? card.name
    end
  end
end