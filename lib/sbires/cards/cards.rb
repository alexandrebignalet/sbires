module Cards
  require 'sbires/cards/card_play_mediator'
  require 'sbires/cards/play'

  module PlayHandlers
    require 'sbires/cards/play_handlers/demonstration'
    require 'sbires/cards/play_handlers/fossoyeur'
    require 'sbires/cards/play_handlers/crieur_public'
  end

  module Middlewares
    require 'sbires/cards/middlewares/play_logger'
  end
end