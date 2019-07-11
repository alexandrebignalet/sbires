module PlayHandlers
  class Weapon
    def run(play)
      raise Sbires::Error, "Not in duel" unless play.game.state.is_a? Duel
    end

    def listen_to(card)
      [CardType::ARMURE_COMPLETE].include? card.name
    end
  end
end