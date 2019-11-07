class Duel < PlayCards

  attr_reader :attacker, :defender

  def initialize(game, defender, dice_roller = DiceRoller.new)
    super(game)
    @dice_roller = dice_roller

    @attacker = Attacker.new game.current_player
    @defender = Defender.new defender

    @attacker_equipment = nil
    @defender_equipment = nil

    @attack_roll = []
    @defense_roll = []
  end

  def roll_dice(lord_name)
    if !@attacker.rolled?
      @attacker.roll_dices(lord_name)
    else
      @defender.roll_dices(lord_name, @attacker.touches)
    end
  end

  def end_turn
    raise Sbires::Error, "Cannot end duel before attack" unless @attacker.rolled?
    raise Sbires::Error, "Cannot end duel before defense plays since attack succeed" if defender_turn?

    change_points
    @game.transition_to PlayCards.new(@game)

    { touches: @attacker.touches, blocks: @defender.blocks }.merge(result)
  end

  def re_roll(player, target_dice)
    is_defender = @defender.is_player?(player)

    duelist = is_defender ? @defender : @attacker

    duelist.re_roll(target_dice)
  end

  def equip(player, card)
    raise Sbires::Error, "Only duelists can equip" unless duelist? player
    is_defender = @defender.is_player?(player)
    raise Sbires::Error, "Defender cannot equip after attacker rolled" if @attacker.rolled? && is_defender

    duelist = is_defender ? @defender : @attacker
    duelist.equip(card)
  end

  def duelist?(player)
    @attacker.is_player?(player) || @defender.is_player?(player)
  end

  private

  def change_points
    if @attacker == result[:winner]
      @attacker.win
      @defender.loose(@attacker.touches)
    else
      @attacker.loose
      @defender.win
    end
  end

  def result
    return { winner: @defender, loser: @attacker } if @attacker.missed?
    return { winner: nil, loser: nil } if !@defender.rolled? && !@attacker.rolled?

    if @defender.blocks >= @attacker.touches
      { winner: @defender, loser: @attacker }
    else
      { winner: @attacker, loser: @defender }
    end
  end

  def defender_turn?
    @attacker.succeeded? && !@defender.rolled?
  end
end