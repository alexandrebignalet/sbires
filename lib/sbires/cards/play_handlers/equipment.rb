module PlayHandlers
  class Equipment
    def run(play)
      raise Sbires::Error, "Not in duel" unless play.game.state.is_a? Duel
    end

    def listen_to(card)
      card.equipment?
    end
  end
end