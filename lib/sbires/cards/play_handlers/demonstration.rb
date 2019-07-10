module PlayHandlers
  class Demonstration
    def run(game, play)
      current_player = game.current_player
      raise Sbires::Error, "Not your turn" if play.submitter_lord_name != current_player.lord_name
      current_player.spare_card(play.card_name)

      game.end_turn
    end

    def listen_to(card_name)
      [CardType::DEMONSTRATION_MENESTREL].include? card_name
    end
  end
end