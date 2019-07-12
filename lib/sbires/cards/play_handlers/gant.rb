module PlayHandlers
  class Gant
    def run(play)
      defender_lord_name = play.params[:target]
      raise Sbires::Error, "Duel needs a target opponent" if defender_lord_name.nil?
      defender = play.game.find_player(defender_lord_name)
      raise Sbires::Error, "Unknown player targeted" if defender.nil?

      play.game.transition_to Duel.new(play.game, defender)
    end

    def listen_to(card)
      [CardType::GANT].include? card.name
    end
  end
end