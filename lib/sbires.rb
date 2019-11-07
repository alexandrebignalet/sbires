require 'sbires/version'

module Sbires

  class Error < StandardError; end

  require 'sbires/game/game'
  require 'sbires/game/states/game_state'
  require 'sbires/game/states/play_cards'
  require 'sbires/game/states/pawn_placement'
  require 'sbires/game/states/bagarre_generale_state'
  require 'sbires/game/states/duel/duel'
  require 'sbires/game/states/duel/duelist'
  require 'sbires/game/states/duel/attacker'
  require 'sbires/game/states/duel/defender'
  require 'sbires/game/states/dice_roller'
  require 'sbires/cards/card'
  require 'sbires/cards/card_type'
  require 'sbires/neighbour'
  require 'sbires/neighbour_type'
  require 'sbires/player'
  require 'sbires/pawn'
  require 'sbires/deck_factory'

  module Cards
    require 'sbires/cards/cards'
  end
end
