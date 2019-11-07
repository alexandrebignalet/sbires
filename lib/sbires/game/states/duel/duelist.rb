class Duelist
  MAX_DICE_NUMBER = 3
  MAX_DICE_ROLL = 6

  def initialize(player, dice_roller = DiceRoller.new)
    @player = player
    @equipment = nil
    @dice_rolls = []
    @dice_roller = dice_roller
  end

  def roll_dices(lord_name, dice_number = MAX_DICE_NUMBER)
    raise Sbires::Error, "#{@player.lord_name} must roll #{self.class.name} dice" if lord_name != @player.lord_name
    @dice_rolls = @dice_roller.roll(dice_number)
  end

  def dice_result(min_success_value)
    success_range = ->() { (min_success_value...MAX_DICE_ROLL) }

    successes = @dice_rolls.select do |roll|
      @equipment ? success_range.call.include?(roll) : roll == MAX_DICE_ROLL
    end

    successes.length
  end

  def rolled?
    @dice_rolls.length > 0
  end

  def is_player? player
    @player == player
  end

  def equip(card)
    raise Sbires::Error, "#{self.class.name} cannot change equipment" if @equipment

    @equipment = card
  end

  def re_roll(target_dice)
    raise Sbires::Error, "You did not make a #{target_dice} dice roll" unless @dice_rolls.include?(target_dice)

    dice_rerolled_index = @dice_rolls.index target_dice
    @dice_rolls[dice_rerolled_index] = @dice_roller.roll(1).first
  end
end