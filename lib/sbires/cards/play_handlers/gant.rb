module PlayHandlers
  class Gant
    def run(play)
      defender_lord_name = play.params[:opponent]
      raise Sbires::Error, "Duel needs an opponent" if defender_lord_name.nil?
      defender = play.game.find_player(defender_lord_name)
      raise Sbires::Error, "Unknown opponent" if defender.nil?
      raise Sbires::Error, "Cannot Duel yourself" if defender == play.game.current_player

      play.game.transition_to Duel.new(play.game, defender)
    end

    def listen_to(card)
      [CardType::GANT].include? card.name
    end
  end
end