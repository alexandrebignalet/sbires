RSpec.describe Sbires do
  let(:player_names) { %w(Jean Francois) }

  it "should not be launch with less than 2 player or more than 5" do
    expect { Game.new([]) }.to raise_error Sbires::Error
    expect { Game.new(["player1"]) }.to raise_error Sbires::Error
    expect { Game.new(%w(player1 player2 player3 player4 player5 player6)) }.to raise_error Sbires::Error
  end

  context "when game start" do
    before do
      @game = Game.new(player_names)
      @players = @game.players
      @player_one = @players.first
      @player_two = @players.last
    end

    it "should be in phase 1" do
      expect(@game.state).to be_instance_of PawnPlacement
    end

    it "game should create players" do
      expect(@players.map(&:name)).to eq(player_names)
    end

    it "game should elect the first player" do
      expect(@game.current_player).not_to be nil
      expect(@players.map(&:lord_name)).to include(@game.current_player.lord_name)
    end

    it "game should assign a lord name for each players" do
      expect(Game::LORD_NAMES).to include(@player_one.lord_name)
      expect(Game::LORD_NAMES).to include(@player_two.lord_name)
    end

    it "game should give 5 points for each players" do
      expect(@player_one.points).to eq 5
      expect(@player_two.points).to eq 5
    end
  end
end