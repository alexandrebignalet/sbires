module Middlewares
  class DuelCardRestrict
    def intercept(play, next_middleware)
      game_state = play.game.state
      card = play.card

      raise Sbires::Error, "Only equipment and buffs can be drawn during a duel" if duel?(game_state) && not_duel_card?(card)

      next_middleware.call
    end

    private

    def not_duel_card?(card)
      !card.equipment? && !card.buff?
    end

    def duel?(state)
      state.is_a?(Duel)
    end
  end
end