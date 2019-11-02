module Sbires
  class Configuration

    attr_accessor :game_repository

    def initialize
      @game_repository ||= InMemoryRepository.new
    end

  end
end