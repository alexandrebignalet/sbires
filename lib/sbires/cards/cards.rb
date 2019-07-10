module Cards
  require 'sbires/cards/card_play_mediator'
  require 'sbires/cards/play'

  module PlayHandlers
    require 'sbires/cards/play_handlers/demonstration'
    require 'sbires/cards/play_handlers/fossoyeur'
  end

  module Plays
    require 'sbires/cards/plays/play_fossoyeur'
  end
end