module PlayHandlers
  class Fossoyeur
    def run(play)
      raise Sbires::Error, "Not your turn" unless play.submitter == play.game.current_player

      current_player = play.game.current_player
      neighbour = play.game.find_neighbour(play.params[:neighbour_discard])

      current_player.pick_card_in_discard(neighbour, play.params[:chosen_card_name])

      play.game.end_turn
    end

    def listen_to(card)
      [CardType::FOSSOYEUR].include? card.name
    end
  end
end