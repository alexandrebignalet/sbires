module PlayHandlers
  class Fossoyeur
    def run(game, card, player, play)
      current_player = game.current_player
      raise Sbires::Error, "Not your turn" unless player == current_player

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