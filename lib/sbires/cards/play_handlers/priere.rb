require_relative './equipment'

module PlayHandlers
  class Priere

    def run(play)
      game_state = play.game.state
      player = play.submitter
      card = play.card

      if game_state.is_a? Duel
        raise Sbires::Error, "You are not in the duel" unless game_state.duelist? player
        raise Sbires::Error, "You must use this card after rolling dices" unless game_state.attacker.rolled? || game_state.defender.rolled?
        raise Sbires::Error, "Too late defender already played" if game_state.attacker.is_player?(player) && game_state.defender.rolled?
        rerolled_dice = play.params[:reroll_dice]
        raise Sbires::Error, "You must target a dice to reroll" if rerolled_dice.nil?

        game_state.re_roll(player, rerolled_dice)
      else
        player.spare_card card
        play.game.end_turn
      end
    end

    def listen_to(card)
      card.buff?
    end
  end
end
