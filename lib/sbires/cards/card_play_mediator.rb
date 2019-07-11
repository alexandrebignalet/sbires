class CardPlayMediator

  def initialize
    @handlers = PlayHandlers.constants.map { |h| PlayHandlers.const_get(h).send(:new) }
  end

  def notify(play)
    handler = @handlers.detect { |h| h.listen_to(play.card) }
    raise Sbires::Error, "Play associated with this card is not handle yet" if handler.nil?

    handler.run(play)
  end
end