RSpec.describe CreateGameHandler do

  it "should save the created game" do
    repository = InMemoryRepository.new
    handler = CreateGameHandler.new(repository)

    player_names = %w(Jean Francois)
    command = CreateGame.new(player_names)

    game = handler.call(command)

    expect(game).to_not be nil
    created_game = repository.load(game.id)
    expect(created_game).to_not be nil
    expect(created_game.id).to eq game.id
  end
end
