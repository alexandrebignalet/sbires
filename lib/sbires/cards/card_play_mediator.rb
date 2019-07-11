class CardPlayMediator

  def initialize
    @handlers = PlayHandlers.constants.map { |h| PlayHandlers.const_get(h).send(:new) }
  end

  def notify(game, card, player, play)
    handler = @handlers.detect { |h| h.listen_to(card.name) }
    raise Sbires::Error, "Play associated with this card is not handle yet" if handler.nil?

    handler.run(game, card, player, play)
  end
end