module PlayHandlers
  class Equipment
    def run(play)
      game_state = play.game.state
      player = play.submitter
      card = play.card
      raise Sbires::Error, "Not in duel" unless game_state.is_a? Duel
      raise Sbires::Error, "Only duelists can equip" unless game_state.duelist? player

      game_state.equip(player, card)

      neighbour = play.game.find_neighbour card.neighbour_name
      player.discard_in(card, neighbour)
    end

    def listen_to(card)
      card.equipment?
    end
  end
end
