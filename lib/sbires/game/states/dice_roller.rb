class DiceRoller

  def roll(dice_number)
    (1...dice_number).map(&dice_roll_sample)
  end

  private
  def dice_roll_sample
    [1...6].sample
  end
end