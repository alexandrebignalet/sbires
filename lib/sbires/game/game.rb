require 'sbires/neighbour_type'
require 'securerandom'

class Game
  LORD_NAMES = ["De Sinople", "D'Azure", "De Gueules", "D'Or", "D'Argent"]
  NEIGHBOURS_NAMES = [NeighbourType::CHATEAU,
                      NeighbourType::TAVERNE,
                      NeighbourType::SALLE_D_ARMES,
                      NeighbourType::GRAND_PLACE,
                      NeighbourType::EGLISE]
  MIN_PLAYERS_IN_GAME = 2
  MAX_PLAYERS_IN_GAME = 5

  attr_reader :players, :neighbours,
              :state, :play_mediator,
              :current_day, :day_skippers,
              :current_player_index, :id

  def self.prepare_players(player_names)
    remaining_lord_names = Game::LORD_NAMES.dup
    player_names.map do |name|
      Player.new(name, remaining_lord_names.shift)
    end
  end

  def self.prepare_neighbours(players_count, deck_factory = DeckFactory.new)
    NEIGHBOURS_NAMES.map { |name| Neighbour.new(name, players_count, deck_factory) }
  end

  def initialize(players,
                 current_player_index: 0,
                 current_day: 1,
                 neighbours: Game.prepare_neighbours(players.length),
                 id: nil)
    raise Sbires::Error, "Not enough player to start the game" if players.length < MIN_PLAYERS_IN_GAME
    raise Sbires::Error, "Too much players to start the game" if players.length > MAX_PLAYERS_IN_GAME

    @id = id || SecureRandom.uuid
    @play_mediator = CardPlayMediator.new
    @players = players
    @first_player_to_play_idx = current_player_index
    @current_player_index = current_player_index
    @neighbours = neighbours
    @current_day = current_day
    @day_skippers = []

    transition_to PawnPlacement.new(self)
  end

  def transition_to(state)
    @state = state
  end

  def current_player
    @players[@current_player_index]
  end

  ############# PAWN PLACEMENT ###########
  def place_pawn(lord_name, neighbour_name)
    state.place_pawn(lord_name, neighbour_name)
  end

  def finish_first_phase
    state.finish_first_phase
  end

  def first_phase_over?
    players.all?(&:all_pawns_placed?)
  end
  ###### PAWN PLACEMENT ########

  ###### PLAY CARDS ##########
  def draw_card(lord_name, card_name, play_params = {})
    state.draw_card(lord_name, card_name, play_params)
  end

  def use_card_effect(lord_name, card_name)
    player = find_player lord_name
    card = player.find_card_in_spare card_name

    # specific to VAILLANCE handling
    raise Sbires::Error, "There is nothing to protect against" unless state.is_a?(ParryableAttackState)
    card.use!
    transition_to PlayCards.new self
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
    @current_player_index = next_player_index

    state.end_turn
  end

  def end_day_for(player)
    raise Sbires::Error, "Not your turn" unless current_player == player
    raise Sbires::Error, "Cannot end of day before play cards phase" unless state.is_a? PlayCards

    end_turn

    @day_skippers << player.lord_name

    end_day if all_players_skipped?
  end

  def neighbours_dominants
    neighbours
        .select { |neighbour| neighbour.dominant }
        .map { |neighbour| [neighbour.dominant, neighbour]}
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
    next_p = nil
    cpi = players.index { |p| p.lord_name == current_player.lord_name }
    npi = cpi == players.length - 1 ? 0 : cpi + 1

    while next_p.nil? do
      player = players[npi]
      next_p = npi unless @day_skippers.include?(player.lord_name)
      npi = npi < players.length - 1 ? npi + 1 : 0
    end

    next_p
  end

  def do_not_protect(lord_name)
    player = find_player lord_name
    raise Sbires::Error, "No attack to parry" unless state.is_a? ParryableAttackState
    raise Sbires::Error, "You are not attacked" unless player == state.target_player

    state.run_effect

    transition_to PlayCards.new self
  end

  private

  def all_players_skipped?
    @day_skippers.size == players.size
  end

  def end_day
    return if @current_day == 4

    resat_players = players.map(&:reset)
    @players = resat_players
    @first_player_to_play_idx = @first_player_to_play_idx == players.length - 1 ? 0 : @first_player_to_play_idx + 1
    @current_player_index = @first_player_to_play_idx
    @current_day = @current_day + 1
    @neighbours = Game.prepare_neighbours(resat_players.length)
    @day_skippers = []

    transition_to PawnPlacement.new(self)
  end
end