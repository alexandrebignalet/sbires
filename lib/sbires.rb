require 'sbires/version'
require 'securerandom'

module Sbires
  class Error < StandardError; end

  LORD_NAMES = ["De Sinople", "D'Azure", "De Gueules", "D'Or", "D'Argent"]
  MIN_PLAYERS_IN_GAME = 2
  MAX_PLAYERS_IN_GAME = 5

  class Game
    attr_reader :players, :current_player

    def initialize(players)
      raise Error, "Not enough player to start the game" if players.length < MIN_PLAYERS_IN_GAME
      raise Error, "Too much players to start the game" if players.length > MAX_PLAYERS_IN_GAME

      @players = prepare_players(players)
      @current_player = @players.sample.lord_name
    end

    private

    def prepare_players(players)
      remaining_lord_names = LORD_NAMES.dup
      players.map {|name| Player.new(name, remaining_lord_names.shift)}
    end
  end

  class Player
    PEON_PER_PLAYER = 8

    attr_reader :name, :lord_name, :peons

    def initialize(name, lord_name)
      @name = name
      @lord_name = lord_name
      @peons = PEON_PER_PLAYER
    end

    def place_peon_on(neighbour)
      neighbour.receive_peon_from(lord_name)
      @peons -= 1
    end
  end

  class Neighbour
    attr_reader :name

    def initialize(name, players_in_game)
      @name = name
      @peons = []
      @players_in_game = players_in_game
    end

    def receive_peon_from(lord_name)
      raise Error, "Neighbour is full" if full?

      @peons << Peon.new(lord_name)
    end

    def full?
      @peons.length >= current_peon_limit
    end

    private

    def current_peon_limit
      peon_limits = {
          MIN_PLAYERS_IN_GAME => 4,
          3 => 5,
          4 => 7,
          MAX_PLAYERS_IN_GAME => 8
      }

      peon_limits[@players_in_game]
    end
  end

  class Peon
    def initialize(belongs_to)
      @belongs_to = belongs_to
    end
  end
end
