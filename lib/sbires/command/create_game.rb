class CreateGame
  attr_reader :player_names

  def initialize(player_names)
    @player_names = player_names
  end
end

class CreateGameHandler
  def initialize(repository)
    @repository = repository
  end

  def call(command)
    game = Game.new(command.player_names)

    @repository.add(game)

    game.id
  end
end