require 'sbires/version'

module Sbires
  class Error < StandardError; end

  LORD_NAMES = ["De Sinople", "D'Azure", "De Gueules", "D'Or", "D'Argent"]
  NEIGHBOURS_NAMES = ["Le Château", "La Taverne", "La Salle d'Armes", "La Grand Place", "L'Eglise"]
  MIN_PLAYERS_IN_GAME = 2
  MAX_PLAYERS_IN_GAME = 5

  class Game
    attr_reader :players, :current_player_name, :neighbours

    def initialize(players)
      raise Error, "Not enough player to start the game" if players.length < MIN_PLAYERS_IN_GAME
      raise Error, "Too much players to start the game" if players.length > MAX_PLAYERS_IN_GAME

      @players = prepare_players(players)
      @current_player_name = @players.sample.lord_name
      @neighbours = create_neighbours
    end

    def place_pawn(lord_name, neighbour_name)
      player = player(lord_name)
      raise Error, "Player #{lord_name} unknown" if player.nil?
      raise Error, "Not your turn" unless player.lord_name == current_player_name
      neighbour = @neighbours.detect { |n| n.name == neighbour_name }
      raise Error, "Neighbour #{neighbour_name} unknown" if neighbour.nil?

      player.place_pawn_on(neighbour)
      player.pick_card_from(neighbour)

      next_player
    end

    def player(lord_name)
      players.detect { |p| p.lord_name == lord_name }
    end
    private

    def create_neighbours
      NEIGHBOURS_NAMES.map {|name| Neighbour.new(name, players.length)}
    end

    def next_player
      @current_player_name = players[next_player_index]
    end

    def next_player_index
      index_of_current_player = players.index { |p| p.lord_name == current_player_name }
      index_of_current_player == players.length ? 0 : ++index_of_current_player
    end

    def prepare_players(players)
      remaining_lord_names = LORD_NAMES.dup
      players.map {|name| Player.new(name, remaining_lord_names.shift)}
    end
  end

  class Player
    PAWN_PER_PLAYER = 8
    INITIAL_POINT_NUMBER = 5

    attr_reader :name, :lord_name, :pawns, :points, :cards

    def initialize(name, lord_name)
      @name = name
      @lord_name = lord_name
      @points = INITIAL_POINT_NUMBER
      @pawns = (0...PAWN_PER_PLAYER).map { Pawn.new(@lord_name) }
      @cards = []
    end

    def place_pawn_on(neighbour)
      raise Error, "No more pawns to place" if all_pawns_placed?
      neighbour.receive_pawn_from(pawns.shift)
    end

    def pick_card_from(neighbour)
      @cards << neighbour.shift_deck
    end

    def discard_in(card, neighbour)
      raise Error, "Not your card" unless cards.include? card

      neighbour.add_discarded(card)
      @cards.delete card
    end

    private

    def all_pawns_placed?
      pawns.length == 0
    end
  end
  class Pawn
    def initialize(belongs_to)
      @belongs_to = belongs_to
    end
  end

  class Neighbour
    CARD_NUMBER_PER_NEIGHBOUR = 26

    attr_reader :name, :deck, :discard

    def initialize(name, players_in_game)
      @name = name
      @pawns = []
      @players_in_game = players_in_game
      @deck = (0...CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(@name) }
      @discard = []
    end

    def receive_pawn_from(pawn)
      raise Error, "Neighbour is full" if full?
      @pawns << pawn
    end

    def shift_deck
      @deck.shift
    end

    def add_discarded(card)
      @discard << card
    end

    def full?
      @pawns.length >= current_pawn_limit
    end

    private

    def current_pawn_limit
      pawn_limits = {
          MIN_PLAYERS_IN_GAME => 4,
          3 => 5,
          4 => 7,
          MAX_PLAYERS_IN_GAME => 8
      }

      pawn_limits[@players_in_game]
    end
  end

  class Card
    attr_reader :neighbour_name

    def initialize(neighbour_name)
      @neighbour_name = neighbour_name
    end
  end
end
