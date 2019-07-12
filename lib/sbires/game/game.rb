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

  attr_reader :players, :current_player, :neighbours, :state, :play_mediator

  def initialize(players)
    raise Sbires::Error, "Not enough player to start the game" if players.length < MIN_PLAYERS_IN_GAME
    raise Sbires::Error, "Too much players to start the game" if players.length > MAX_PLAYERS_IN_GAME

    @play_mediator = CardPlayMediator.new
    @players = prepare_players(players)
    @current_player = @players.sample
    @neighbours = create_neighbours DeckFactory.new

    transition_to PawnPlacement.new(self)
  end

  def transition_to(state)
    @state = state
  end

  ############# PAWN PLACEMENT ###########
  def place_pawn(lord_name, neighbour_name)
    state.place_pawn(lord_name, neighbour_name)
  end

  def finish_first_phase
    state.finish_first_phase
  end

  def first_phase_over?
    players.all? { |p| p.all_pawns_placed? }
  end
  ###### PAWN PLACEMENT ########

  ###### PLAY CARDS ##########
  def draw_card(lord_name, card_name, play_params = {})
    state.draw_card(lord_name, card_name, play_params)
  end

  def discard_spare_card(lord_name, card_name)
    state.discard_spare_card(lord_name, card_name)
  end

  ###### PLAY CARDS ##########

  ###### DUEL ##########

  def roll_dice(lord_name)
    state.roll_dice(lord_name)
  end

  ###### DUEL ##########

  def end_turn
    @current_player = players[next_player_index]
  end

  def neighbours_dominants
    neighbours.map { |neighbour| [neighbour.dominant, neighbour]}
  end

  def find_player(lord_name)
    player = players.detect { |p| p.lord_name == lord_name }
    raise Sbires::Error, "Unknown player #{lord_name}" if player.nil?
    player
  end

  def find_neighbour(neighbour_name)
    neighbour = neighbours.detect { |n| n.name == neighbour_name }
    raise Sbires::Error, "Unknown neighbour" if neighbour.nil?
    neighbour
  end

  def next_player_index
    index_of_current_player = players.index { |p| p.lord_name == current_player.lord_name }
    index_of_current_player == players.length - 1 ? 0 : index_of_current_player + 1
  end

  private

  def create_neighbours(deck_factory)
    NEIGHBOURS_NAMES.map {|name| Neighbour.new(name, players.length, deck_factory)}
  end

  def prepare_players(players)
    remaining_lord_names = LORD_NAMES.dup
    players.map {|name| Player.new(name, remaining_lord_names.shift)}
  end
end