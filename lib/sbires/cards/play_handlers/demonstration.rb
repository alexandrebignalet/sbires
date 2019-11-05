module PlayHandlers
  class Demonstration
    def run(play)
      raise Sbires::Error, "Not your turn" unless play.submitter == play.game.current_player

      current_player = play.game.current_player
      raise Sbires::Error, "No more than 3 demonstrations in spare allowed" if current_player.three_demonstration_in_spare?

      current_player.spare_card(play.card)

      play.game.end_turn
    end

    def listen_to(card)
      CardType.demonstration_cards.include? card.name
    end
  end
end