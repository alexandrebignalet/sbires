module Sbires
  RSpec.describe Sbires do

    it "should not be launch with less than 2 player or more than 5" do
      expect { Game.new([]) }.to raise_error Error
      expect { Game.new(["player1"]) }.to raise_error Error
      expect { Game.new(["player1", "player2", "player3", "player4", "player5", "player6"]) }.to raise_error Error
    end

    context "game start" do
      let(:player_names) { %w(Jean Francois) }

      before do
        @game = Game.new(player_names)
        @players = @game.players
        @player_one = @players.first
        @player_two = @players.last
      end

      it "game should create players" do
        expect(@players.map(&:name)).to eq(player_names)
      end

      it "game should elect the first player" do
        expect(@game.current_player).not_to be nil
        expect(@players.map(&:lord_name)).to include(@game.current_player)
      end

      it "game should assign a lord name for each players" do
        puts @players.map(&:lord_name)
        expect(LORD_NAMES).to include(@players_one.lord_name)
        expect(LORD_NAMES).to include(@players_two.lord_name)
      end
    end

    context "Neighbour" do

        it "a player should be allowed to place peon on a neighbour" do
          neighbour = Neighbour.new("Taverne", 2)
          player = Player.new("Jean", LORD_NAMES[0])

          player.place_peon_on(neighbour)

          expect(neighbour.full?).to be false
          expect(player.peons).to be Player::PEON_PER_PLAYER - 1
        end

        it "neighbour should be full with 4 peons when 2 players in game" do
          player = Player.new("Jean", LORD_NAMES[0])
          neighbour = Neighbour.new("Taverne", 2)

          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)

          expect(neighbour.full?).to be true
        end

        it "neighbour should raise if player try to put a peon on a full neighbour" do
          player = Player.new("Jean", LORD_NAMES[0])
          neighbour = Neighbour.new("Taverne", 2)

          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          expect { player.place_peon_on(neighbour) }.to raise_error Error
        end

        it "neightbour should be full with 5 peons when 3 players in game" do
          player = Player.new("Jean", LORD_NAMES[0])
          neighbour = Neighbour.new("Taverne", 3)

          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)
          player.place_peon_on(neighbour)

          expect(neighbour.full?).to be true
        end
      end

    context "Game peon placement" do
      it "game should not allow a player to place multiple peons consecutively" do

      end
    end
  end
end