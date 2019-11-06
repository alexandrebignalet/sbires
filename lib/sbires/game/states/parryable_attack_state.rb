class ParryableAttackState < PlayCards
  attr_reader :target_player, :attack_card

  def initialize(game, target_player, attack_card)
    @target_player = target_player
    @attack_card = attack_card
  end

  def draw_card(lord_name, card_name, play_params = {})
    raise Sbires::Error, "You should not draw card on parryable attack state"
  end

  def discard_spare_card(lord_name, card_name)
    raise Sbires::Error, "#{self.class.name}: You are not targetted by the attack" if target_player.lord_name != lord_name
    card = target_player.find_card_in_spare card_name

  end
end