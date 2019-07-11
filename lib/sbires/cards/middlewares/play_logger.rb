module Middlewares
  class PlayLogger
    def intercept(play, next_middleware)
      puts "before play of #{play.submitter.lord_name}: #{play.card.name}"

      response = next_middleware.call

      puts "logger log: #{response}"
    end
  end
end