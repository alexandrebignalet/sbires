class Game
  LORD_NAMES = ["De Sinople", "D'Azure", "De Gueules", "D'Or", "D'Argent"]
  NEIGHBOURS_NAMES = ["Le Château", "La Taverne", "La Salle d'Armes", "La Grand Place", "L'Eglise"]
  MIN_PLAYERS_IN_GAME = 2
  MAX_PLAYERS_IN_GAME = 5

  attr_reader :players, :current_player, :neighbours, :current_phase

  def initialize(players)
    raise Sbires::Error, "Not enough player to start the game" if players.length < MIN_PLAYERS_IN_GAME
    raise Sbires::Error, "Too much players to start the game" if players.length > MAX_PLAYERS_IN_GAME

    @players = prepare_players(players)
    @current_player = @players.sample
    @neighbours = create_neighbours
    @current_phase = 1
  end

  def place_pawn(lord_name, neighbour_name)
    player = player(lord_name)
    raise Sbires::Error, "Player #{lord_name} unknown" if player.nil?
    raise Sbires::Error, "Not your turn" unless player.lord_name == current_player.lord_name
    neighbour = neighbours.detect { |n| n.name == neighbour_name }
    raise Sbires::Error, "Neighbour #{neighbour_name} unknown" if neighbour.nil?

    player.place_pawn_on(neighbour)
    player.pick_card_from(neighbour)

    finish_first_phase if first_phase_over?

    next_player
  end

  def finish_first_phase
    neighbours.each do |neighbour|
      next unless neighbour.dominant

      dominant = player(neighbour.dominant)
      dominant.pick_card_from(neighbour)
    end
    @current_phase = 2
  end

  def first_phase_over?
    players.all? { |p| p.all_pawns_placed? }
  end

  def player(lord_name)
    players.detect { |p| p.lord_name == lord_name }
  end

  private

  def create_neighbours
    NEIGHBOURS_NAMES.map {|name| Neighbour.new(name, players.length)}
  end

  def next_player
    @current_player = players[next_player_index]
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