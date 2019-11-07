class Defender < Duelist
  DEFENSE_SUCCESS_POINTS = 2

  def roll_dices(lord_name, attacks_count)
    super(lord_name, attacks_count)
  end

  def blocks
    count_blocks @dice_rolls
  end

  def count_blocks(dice_result)
    success_range = ->() { (@equipment.min_block...MAX_DICE_ROLL) }

    blocks = dice_result.select do |roll|
      @equipment ? success_range.call.include?(roll) : roll == MAX_DICE_ROLL
    end

    blocks.length
  end

  def loose(touches_count)
    @player.change_points(blocks - touches_count)
  end

  def win
    @player.change_points(DEFENSE_SUCCESS_POINTS)
  end
end