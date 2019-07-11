module Cards
  require 'sbires/cards/card_play_mediator'
  require 'sbires/cards/play'

  module PlayHandlers
    require 'sbires/cards/play_handlers/demonstration'
    require 'sbires/cards/play_handlers/fossoyeur'
    require 'sbires/cards/play_handlers/crieur_public'
    require 'sbires/cards/play_handlers/bagarre_generale'
    require 'sbires/cards/play_handlers/weapon'
  end

  module Middlewares
    require 'sbires/cards/middlewares/play_logger'
    require 'sbires/cards/middlewares/player_turn'
  end
end