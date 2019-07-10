class CardPlayMediator

  def initialize
    @handlers = PlayHandlers.constants.map { |h| PlayHandlers.const_get(h).send(:new) }
  end

  def notify(game, play)
    handler = @handlers.detect { |h| h.listen_to(play.card_name) }
    raise Sbires::Error, "Play associated with this card is not handle yet" if handler.nil?

    handler.run(game, play)
  end
end