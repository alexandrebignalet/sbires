module Cards
  require 'sbires/domain/cards/card_play_mediator'
  require 'sbires/domain/cards/play'

  module PlayHandlers
    require 'sbires/domain/cards/play_handlers/demonstration'
    require 'sbires/domain/cards/play_handlers/fossoyeur'
    require 'sbires/domain/cards/play_handlers/crieur_public'
    require 'sbires/domain/cards/play_handlers/bagarre_generale'
    require 'sbires/domain/cards/play_handlers/gant'
    require 'sbires/domain/cards/play_handlers/priere'
    require 'sbires/domain/cards/play_handlers/equipment'
  end

  module Middlewares
    require 'sbires/domain/cards/middlewares/play_logger'
    require 'sbires/domain/cards/middlewares/duel_card_restrict'
  end
end