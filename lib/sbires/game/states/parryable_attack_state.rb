class ParryableAttackState < PlayCards
  attr_reader :target_player, :attack_card

  def initialize(game, target_player, attack_card, effect)
    @game = game
    @target_player = target_player
    @attack_card = attack_card
    @effect = effect
  end

  def draw_card(lord_name, card_name, play_params = {})
    raise Sbires::Error, "You should not draw card on parryable attack state"
  end

  def run_effect
    @effect.call
  end

  def discard_spare_card(lord_name, card_name)
    raise Sbires::Error, "#{self.class.name}: You are not targetted by the attack" if target_player.lord_name != lord_name
    target_player.find_card_in_spare card_name
    raise Sbires::Error, "#{self.class.name}: #{card_name} do not protect against #{attack_card.name}" unless @attack_card.is_parried_by? card_name
  end

  def use_card_effect(lord_name, card_name)
    player = @game.find_player lord_name
    card = player.find_card_in_spare card_name

    card.use!
    @game.end_turn
    @game.transition_to PlayCards.new @game
  end
end