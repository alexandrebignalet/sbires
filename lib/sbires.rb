require 'sbires/version'

module Sbires
  class Error < StandardError; end

  require 'sbires/domain/game/game'
  require 'sbires/domain/game/states/game_state'
  require 'sbires/domain/game/states/play_cards'
  require 'sbires/domain/game/states/pawn_placement'
  require 'sbires/domain/game/states/bagarre_generale_state'
  require 'sbires/domain/game/states/duel'
  require 'sbires/domain/game/states/dice_roller'
  require 'sbires/domain/cards/card'
  require 'sbires/domain/cards/card_type'
  require 'sbires/domain/neighbour'
  require 'sbires/domain/neighbour_type'
  require 'sbires/domain/player'
  require 'sbires/domain/pawn'
  require 'sbires/domain/deck_factory'

  require 'sbires/command/create_game'

  require 'sbires/interfaces/in_memory_repository'

  module Cards
    require 'sbires/domain/cards/cards'
  end
end
