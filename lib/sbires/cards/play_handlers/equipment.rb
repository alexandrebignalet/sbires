module PlayHandlers
  class Equipment
    def run(play)
      game_state = play.game.state
      player = play.submitter
      card = play.card
      raise Sbires::Error, "Not in duel" unless game_state.is_a? Duel
      raise Sbires::Error, "You are not in the duel" unless player == game_state.attacker || player == game_state.defender

      player == game_state.attacker ? game_state.equip_attacker(card) : game_state.equip_defender(card)

      neighbour = play.game.find_neighbour card.neighbour_name
      player.discard_in(card, neighbour)
    end

    def listen_to(card)
      card.equipment?
    end
  end
end
