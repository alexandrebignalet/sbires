module PlayHandlers
  class MontreurDours
    def run(play)
      game = play.game
      target_card_type = play.params[:target_card]
      target_player = game.find_player play.params[:target_player]
      raise Sbires::Error, "#{self.class.name}: You must target an opponent" if target_player == game.current_player
      raise Sbires::Error, "#{self.class.name}: You can only target Demonstrations card" unless CardType.demonstration_cards.include?(target_card_type)

      game.transition_to ParryableAttackState.new(@game, target_player, play.card)

      target_card = target_player.find_card_in_spare(target_card_type)
      target_neighbour = game.find_neighbour(target_card.neighbour_name)
      target_player.discard_spare_in(target_card, target_neighbour)

      neighbour = game.find_neighbour(play.card.neighbour_name)
      game.current_player.discard_in(play.card, neighbour)

      game.end_turn
    end

    def listen_to(card)
      [CardType::MONTREUR_DOURS].include? card.name
    end
  end
end