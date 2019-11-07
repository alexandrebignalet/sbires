class Attacker < Duelist
  ATTACK_SUCCEED_POINTS = 5
  ATTACK_FAILED_POINTS = -1
  MIN_TOUCH_NUMBER = 0

  def equip(card)
    raise Sbires::Error, "You can only draw equipment card after a gant card" if rolled?
    raise Sbires::Error, "Attacker cannot equip after rolling dices" if succeeded?
    super(card)
  end

  def succeeded?
    @dice_rolls.length > 0 && touches > MIN_TOUCH_NUMBER
  end

  def missed?
    touches == MIN_TOUCH_NUMBER
  end

  def touches
    count_touches @dice_rolls
  end

  def count_touches(dice_result)
    success_range = ->() { (@equipment.min_touch...MAX_DICE_ROLL) }

    touches = dice_result.select do |roll|
      @equipment ? success_range.call.include?(roll) : roll == MAX_DICE_ROLL
    end

    touches.length
  end

  def loose
    @player.change_points(ATTACK_FAILED_POINTS)
  end

  def win
    @player.change_points(ATTACK_SUCCEED_POINTS)
  end
end