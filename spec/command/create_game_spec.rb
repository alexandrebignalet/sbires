RSpec.describe CreateGameHandler do

  it "should save the created game" do
    repository = InMemoryRepository.new
    handler = CreateGameHandler.new(repository)

    player_names = %w(Jean Francois)
    command = CreateGame.new(player_names)

    game_id = handler.call(command)

    expect(game_id).to_not be nil
    created_game = repository.get(game_id)
    expect(created_game).to_not be nil
    expect(created_game.id).to eq game_id
  end
end
