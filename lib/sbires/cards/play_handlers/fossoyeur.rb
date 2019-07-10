module PlayHandlers
  class Fossoyeur
    def run(game, play)
      current_player = game.current_player
      raise Sbires::Error, "Not your turn" if play.submitter_lord_name != current_player.lord_name
      raise Sbires::Error, "You must own the card" if current_player.find_card(play.card_name).nil?

      neighbour = game.find_neighbour(play.neighbour_discard)
      raise Sbires::Error, "Unknown neighbour" if neighbour.nil?

      current_player.pick_card_in_discard(neighbour, play.chosen_card_name)

      game.end_turn
    end

    def listen_to(card_name)
      [CardType::FOSSOYEUR].include? card_name
    end
  end
end