class Duel < PlayCards
  MAX_DICE_NUMBER = 3
  MAX_DICE_ROLL = 6
  MIN_TOUCH_NUMBER = 0

  def initialize(game, defender, dice_roller = DiceRoller.new)
    super(game)
    @dice_roller = dice_roller

    @attacker = game.current_player
    @defender = defender

    @attacker_equipment = nil
    @defender_equipment = nil

    @attacks_number = nil
    @blocks_number = nil
  end

  def draw_card(lord_name, card_name, play_params = {})
    player = @game.find_player lord_name
    raise Sbires::Error, "You are not in the duel" unless player == @attacker || player == @defender

    card = player.find_card card_name
    raise Sbires::Error, "You can only draw equipment card after a gant card" unless card.equipment?

    if player == @attacker
      raise Sbires::Error, "Attacker cannot change equipement" if @attacker_equipment
      raise Sbires::Error, "Attacker cannot equip after rolling dices" if @attacks_number

      @attacker_equipment = card
    else
      raise Sbires::Error, "Defender cannot change equipement" if @defender_equipment

      @defender_equipment = card
    end

    neighbour = @game.find_neighbour card.neighbour_name
    player.discard_in(card, neighbour)
  end

  def roll_dice(lord_name)
    raise Sbires::Error, "#{@attacker.lord_name} must roll attack dice" if lord_name != @attacker.lord_name && attacker_turn?
    raise Sbires::Error, "#{@defender.lord_name} must roll defense dice" if lord_name != @defender.lord_name && defender_turn?

    if attacker_turn?
      dice_result = @dice_roller.roll(MAX_DICE_NUMBER)
      @attacks_number = count_touches dice_result
    else
      dice_result = @dice_roller.roll(@attacks_number)
      @blocks_number = count_blocks dice_result
    end

    unless defense_not_done? && attack_succeed
      change_points
      @game.end_turn
      @game.transition_to PlayCards.new(@game)
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
      @defender.won_duel Player::DEFENSE_SUCCESS_POINTS
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
    attack_succeed && defense_not_done?
  end

  def attack_succeed
    @attacks_number && @attacks_number > MIN_TOUCH_NUMBER
  end

  def attack_missed
    @attacks_number && @attacks_number == MIN_TOUCH_NUMBER
  end

  def attacker_turn?
    attack_not_done?
  end

end