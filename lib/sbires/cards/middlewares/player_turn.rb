module Middlewares
  class PlayerTurnChecker
    def intercept(play, next_middleware)
      raise Sbires::Error, "Not your turn" unless play.submitter == play.game.current_player

      next_middleware.call

      play.game.end_turn unless prevent_end_turn?(play.card)
    end

    def prevent_end_turn?(card)
      [CardType::BAGARRE_GENERALE,
       CardType::GANT].include? card.name
    end
  end
end