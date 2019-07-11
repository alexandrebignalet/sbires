class CardPlayMediator

  def initialize
    middlewares = Middlewares.constants.map { |h| Middlewares.const_get(h).send(:new) }

    @middleware_chain = create_chain(middlewares)
  end

  def notify(play)
    @middleware_chain.call(play)
  end

  private

  def create_chain(middlewares)
    middlewares.reduce(final_chain) do |sub_chain, middleware|
      Chain.new(middleware, sub_chain)
    end
  end

  def final_chain
    Chain.new(InvokePlayHandler.new, nil)
  end

  class Chain
    def initialize(middleware, next_chain)
      @current = middleware
      @next_chain = next_chain
    end

    def call(play)
      @current.intercept(play, ->() { @next_chain.call(play) })
    end
  end

  class InvokePlayHandler
    def initialize
      @handlers = PlayHandlers.constants.map { |h| PlayHandlers.const_get(h).send(:new) }
    end

    def intercept(play, next_middleware)
      handler = @handlers.detect { |h| h.listen_to(play.card) }
      raise Sbires::Error, "Play associated with this card is not handle yet" if handler.nil?

      puts "#{handler.class.name} handled #{play}"
      handler.run(play)
    end
  end
end