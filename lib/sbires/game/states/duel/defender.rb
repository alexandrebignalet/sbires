class Defender < Duelist
  DEFENSE_SUCCESS_POINTS = 2

  def roll_dices(lord_name, attacks_count)
    super(lord_name, attacks_count)
  end

  def blocks
    dice_result(@equipment&.min_block)
  end

  def loose(touches_count)
    @player.change_points(blocks - touches_count)
  end

  def win
    @player.change_points(DEFENSE_SUCCESS_POINTS)
  end
end