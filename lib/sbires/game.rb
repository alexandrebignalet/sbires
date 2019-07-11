require 'sbires/neighbour_type'

class Game
  LORD_NAMES = ["De Sinople", "D'Azure", "De Gueules", "D'Or", "D'Argent"]
  NEIGHBOURS_NAMES = [NeighbourType::CHATEAU,
                      NeighbourType::TAVERNE,
                      NeighbourType::SALLE_D_ARMES,
                      NeighbourType::GRAND_PLACE,
                      NeighbourType::EGLISE]
  MIN_PLAYERS_IN_GAME = 2
  MAX_PLAYERS_IN_GAME = 5
  PLACE_PAWNS = 1
  PLAY_CARDS = 2

  attr_reader :players, :current_player, :neighbours, :current_phase

  def initialize(players)
    raise Sbires::Error, "Not enough player to start the game" if players.length < MIN_PLAYERS_IN_GAME
    raise Sbires::Error, "Too much players to start the game" if players.length > MAX_PLAYERS_IN_GAME

    @play_mediator = CardPlayMediator.new
    @players = prepare_players(players)
    @current_player = @players.sample
    @neighbours = create_neighbours
    @current_phase = PLACE_PAWNS
  end

  def place_pawn(lord_name, neighbour_name)
    player = find_player(lord_name)
    raise Sbires::Error, "Player #{lord_name} unknown" if player.nil?
    raise Sbires::Error, "Not your turn" unless player.lord_name == current_player.lord_name
    neighbour = neighbours.detect { |n| n.name == neighbour_name }
    raise Sbires::Error, "Neighbour #{neighbour_name} unknown" if neighbour.nil?

    player.place_pawn_on(neighbour)
    player.pick_top_card_of_deck(neighbour)

    finish_first_phase if first_phase_over?

    end_turn
  end

  def draw_card(play)
    raise Sbires::Error, "Not in phase Play Cards" unless current_phase == PLAY_CARDS
    player = find_player play.submitter_lord_name
    raise Sbires::Error, "Unknown player #{play.submitter_lord_name}" if player.nil?
    card = player.find_card play.card_name
    raise Sbires::Error, "You don't own a card #{play.card_name}" if card.nil?

    @play_mediator.notify(self, card, player, play)
  end

  def finish_first_phase
    neighbours.each do |neighbour|
      next unless neighbour.dominant

      dominant = find_player(neighbour.dominant)
      dominant.pick_top_card_of_deck(neighbour)
    end
    @current_phase = PLAY_CARDS
  end

  def end_turn
    @current_player = players[next_player_index]
  end

  def first_phase_over?
    players.all? { |p| p.all_pawns_placed? }
  end

  def neighbours_dominants
    neighbours.map { |neighbour| [neighbour.dominant, neighbour]}
  end

  def find_player(lord_name)
    players.detect { |p| p.lord_name == lord_name }
  end

  def find_neighbour(neighbour_name)
    neighbours.detect { |n| n.name == neighbour_name }
  end



  private

  def create_neighbours
    NEIGHBOURS_NAMES.map {|name| Neighbour.new(name, players.length)}
  end

  def next_player_index
    index_of_current_player = players.index { |p| p.lord_name == current_player.lord_name }
    index_of_current_player == players.length - 1 ? 0 : index_of_current_player + 1
  end

  def prepare_players(players)
    remaining_lord_names = LORD_NAMES.dup
    players.map {|name| Player.new(name, remaining_lord_names.shift)}
  end
end