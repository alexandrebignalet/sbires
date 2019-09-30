class NewGameHandler
  attr_reader :creator_id, :player_names

  def call
    Game.create_game(player_names)
  end

  def listen_to
    NewGame
  end
end