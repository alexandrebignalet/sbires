module Cards
  require 'sbires/cards/card_play_mediator'
  require 'sbires/cards/play'

  module PlayHandlers
    require 'sbires/cards/play_handlers/demonstration'
    require 'sbires/cards/play_handlers/fossoyeur'
    require 'sbires/cards/play_handlers/crieur_public'
    require 'sbires/cards/play_handlers/bagarre_generale'
    require 'sbires/cards/play_handlers/gant'
    require 'sbires/cards/play_handlers/priere'
    require 'sbires/cards/play_handlers/equipment'
    require 'sbires/cards/play_handlers/montreur_dours'
  end

  module Middlewares
    require 'sbires/cards/middlewares/play_logger'
    require 'sbires/cards/middlewares/duel_card_restrict'
  end
end