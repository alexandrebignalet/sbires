module Middlewares
  class PlayLogger
    def intercept(play, next_middleware)
      # puts "before play of #{play.submitter.lord_name}: #{play.card.name}"

      next_middleware.call

      # puts "logger log: after"
    end
  end
end