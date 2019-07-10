require 'sbires/version'

module Sbires
  class Error < StandardError; end

  require 'sbires/game'
  require 'sbires/card'
  require 'sbires/card_type'
  require 'sbires/neighbour'
  require 'sbires/neighbour_type'
  require 'sbires/player'
  require 'sbires/pawn'
  require 'sbires/deck_factory'

  module Cards
    require 'sbires/cards/cards'
  end
end
