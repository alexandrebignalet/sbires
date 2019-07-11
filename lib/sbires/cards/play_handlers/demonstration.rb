module PlayHandlers
  class Demonstration
    def run(play)
      current_player = play.game.current_player
      raise Sbires::Error, "Not your turn" unless play.submitter == current_player

      current_player.spare_card(play.card)

      play.game.end_turn
    end

    def listen_to(card)
      [CardType::DEMONSTRATION_MENESTREL].include? card.name
    end
  end
end