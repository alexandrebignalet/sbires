require_relative './equipment'

module PlayHandlers
  class Priere

    def run(play)
      @game_state = play.game.state
      @player = play.submitter
      @card = play.card

      if @game_state.is_a? Duel
        raise Sbires::Error, "You are not in the duel" unless attacker_plays? || defender_plays?
        raise Sbires::Error, "You must use this card after rolling dices" unless attacker_and_attacked? || defender_and_defended?
        raise Sbires::Error, "Too late defender already played" if attacker_and_attacked? && defended?
        rerolled_dice = play.params[:reroll_dice]
        raise Sbires::Error, "You must target a dice to reroll" if rerolled_dice.nil?

        attacker_plays? ? @game_state.reroll_attack_dice(rerolled_dice) : @game_state.reroll_defense_dice(rerolled_dice)
      else
        @player.spare_card @card
        play.game.end_turn
      end
    end

    def listen_to(card)
      card.buff?
    end

    private

    def defender_plays?
      @player == @game_state.defender
    end

    def attacker_plays?
      @player == @game_state.attacker
    end

    def attacker_and_attacked?
      attacker_plays? && @game_state.attacks_number
    end

    def defender_and_defended?
      defender_plays? && defended?
    end

    def defended?
      !@game_state.defense_not_done?
    end
  end
end
