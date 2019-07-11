module PlayHandlers
  class BagarreGenerale
    def run(play)
      play.game.transition_to BagarreGeneraleState

      end_turn(play.game) if play.game.state.discardable_opponents.empty?
    end

    def listen_to(card)
      [CardType::BAGARRE_GENERALE].include? card.name
    end

    private
    def end_turn(game)
      game.end_turn
      game.transition_to PlayCards
    end
  end
end