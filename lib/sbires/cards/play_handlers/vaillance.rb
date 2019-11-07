module PlayHandlers
  class Vaillance
    def run(play)
      game = play.game

      play.submitter.change_atout play.card

      game.end_turn
    end

    def listen_to(card)
      [CardType::VAILLANCE].include? card.name
    end
  end
end