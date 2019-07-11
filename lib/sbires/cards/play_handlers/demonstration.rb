module PlayHandlers
  class Demonstration
    def run(game, card, player, play)
      current_player = game.current_player
      raise Sbires::Error, "Not your turn" unless player == current_player

      current_player.spare_card(card)

      game.end_turn
    end

    def listen_to(card_name)
      [CardType::DEMONSTRATION_MENESTREL].include? card_name
    end
  end
end