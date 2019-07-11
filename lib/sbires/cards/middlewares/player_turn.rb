module Middlewares
  class PlayerTurnChecker
    def intercept(play, next_middleware)
      raise Sbires::Error, "Not your turn" unless play.submitter == play.game.current_player

      next_middleware.call

      play.game.end_turn
    end
  end
end