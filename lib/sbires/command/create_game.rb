class CreateGame
  attr_reader :player_names

  def initialize(player_names)
    @player_names = player_names
  end
end

class CreateGameHandler
  def initialize(repository = Sbires.config.game_repository)
    @repository = repository
  end

  def call(command)
    players = Game.prepare_players(command.player_names)

    game = Game.new(players)

    @repository.add(game)

    game
  end
end