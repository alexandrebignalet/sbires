class Duel < PlayCards
  def initialize(game, defender, dice_roller = DiceRoller.new)
    super(game)
    @dice_roller = dice_roller

    @defender = defender
    @attacker = game.current_player

    @attacks_number = nil
    @blocks_number = nil
  end

  def roll_dice(lord_name)
    raise Sbires::Error, "#{@attacker.lord_name} must roll attack dice" if lord_name != @attacker.lord_name && attacker_turn?
    raise Sbires::Error, "#{@defender.lord_name} must roll defense dice" if lord_name != @defender.lord_name && defender_turn?

    if attacker_turn?
      dice_result = @dice_roller.roll(3)
      @attacks_number = count_touches dice_result
    else
      dice_result = @dice_roller.roll(@attacks_number)
      @blocks_number = count_touches @dice_roller.roll(3)
    end

    unless defense_not_done? && attack_succeed
      change_points
      @game.end_turn
    end

    { dice_result: dice_result,
      touches: @attacks_number,
      blocks: @blocks_number }.merge(result)
  end

  private

  def change_points
    if @attacker == result[:winner]
      @attacker.won_duel
      @defender.lost_duel @blocks_number - @attacks_number
    else
      @attacker.lost_duel
      @defender.won_duel 2
    end
  end

  def result
    return { winner: @defender, loser: @attacker } if attack_missed
    return { winner: nil, loser: nil } if defense_not_done? || attack_not_done?

    if @blocks_number >= @attacks_number
      { winner: @defender, loser: @attacker }
    else
      { winner: @attacker, loser: @defender }
    end
  end

  def attack_not_done?
    @attacks_number.nil?
  end

  def defense_not_done?
    @blocks_number.nil?
  end

  def count_touches(dice_result)
    dice_result.select { |d| d == 6 }.length
  end

  def defender_turn?
    attack_succeed && defense_not_done?
  end

  def attack_succeed
    @attacks_number && @attacks_number > 0
  end

  def attack_missed
    @attacks_number && @attacks_number == 0
  end

  def attacker_turn?
    attack_not_done?
  end

end