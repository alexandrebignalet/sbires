class Duel < PlayCards
  MAX_DICE_NUMBER = 3
  MAX_DICE_ROLL = 6
  MIN_TOUCH_NUMBER = 0

  attr_reader :attacker, :defender

  def initialize(game, defender, dice_roller = DiceRoller.new)
    super(game)
    @dice_roller = dice_roller

    @attacker = game.current_player
    @defender = defender

    @attacker_equipment = nil
    @defender_equipment = nil

    @attack_roll = []
    @defense_roll = []
  end

  def roll_dice(lord_name)
    attacker_turn? ? roll_attacker_dices(lord_name) : roll_defender_dices(lord_name)
  end

  def end_turn
    raise Sbires::Error, "Cannot end duel before attack" if attack_not_done?
    raise Sbires::Error, "Cannot end duel before defense since attack succeed" if attack_succeed? && defense_not_done?

    change_points
    @game.transition_to PlayCards.new(@game)

    { touches: attacks_number, blocks: blocks_number }.merge(result)
  end

  def reroll_attack_dice(target_dice)
    raise Sbires::Error, "You did not make a #{target_dice} dice roll" unless @attack_roll.include?(target_dice)

    dice_rerolled_index = @attack_roll.index target_dice
    @attack_roll[dice_rerolled_index] = @dice_roller.roll(1).first
  end

  def reroll_defense_dice(target_dice)
    raise Sbires::Error, "You did not make a #{target_dice} dice roll" unless @defense_roll.include?(target_dice)

    dice_rerolled_index = @defense_roll.index target_dice
    @defense_roll[dice_rerolled_index] = @dice_roller.roll(1).first
  end

  def roll_attacker_dices(lord_name)
    raise Sbires::Error, "#{@attacker.lord_name} must roll attack dice" if lord_name != @attacker.lord_name

    @attack_roll = @dice_roller.roll(MAX_DICE_NUMBER)
  end

  def roll_defender_dices(lord_name)
    raise Sbires::Error, "#{@defender.lord_name} must roll defense dice" if lord_name != @defender.lord_name

    @defense_roll = @dice_roller.roll(attacks_number)
  end

  def equip_attacker(card)
    raise Sbires::Error, "You can only draw equipment card after a gant card" unless attack_not_done?
    raise Sbires::Error, "Attacker cannot change equipment" if @attacker_equipment
    raise Sbires::Error, "Attacker cannot equip after rolling dices" unless @attack_roll.empty?

    @attacker_equipment = card
  end

  def equip_defender(card)
    raise Sbires::Error, "Defender cannot equip after attacker rolled his dices" unless attack_not_done?
    raise Sbires::Error, "Defender cannot change equipment" if @defender_equipment

    @defender_equipment = card
  end

  def attacks_number
    count_touches @attack_roll
  end

  def blocks_number
    count_blocks @defense_roll
  end

  def attack_not_done?
    @attack_roll.empty?
  end

  def defense_not_done?
    @defense_roll.empty?
  end

  private

  def change_points
    if @attacker == result[:winner]
      @attacker.won_duel
      @defender.lost_duel blocks_number - attacks_number
    else
      @attacker.lost_duel
      @defender.won_duel Player::DEFENSE_SUCCESS_POINTS
    end
  end

  def result
    return { winner: @defender, loser: @attacker } if attack_missed?
    return { winner: nil, loser: nil } if defense_not_done? || attack_not_done?

    if blocks_number >= attacks_number
      { winner: @defender, loser: @attacker }
    else
      { winner: @attacker, loser: @defender }
    end
  end

  def count_touches(dice_result)
    success_range = ->() { (@attacker_equipment.min_touch...MAX_DICE_ROLL) }

    touches = dice_result.select do |roll|
      @attacker_equipment ? success_range.call.include?(roll) : roll == MAX_DICE_ROLL
    end

    touches.length
  end

  def count_blocks(dice_result)
    success_range = ->() { (@defender_equipment.min_block...MAX_DICE_ROLL) }

    blocks = dice_result.select do |roll|
      @defender_equipment ? success_range.call.include?(roll) : roll == MAX_DICE_ROLL
    end

    blocks.length
  end

  def defender_turn?
    attack_succeed? && defense_not_done?
  end

  def attack_succeed?
    @attack_roll.length > 0 && attacks_number > MIN_TOUCH_NUMBER
  end

  def attack_missed?
    @attack_roll.length > 0 && attacks_number == MIN_TOUCH_NUMBER
  end

  def attacker_turn?
    attack_not_done?
  end
end