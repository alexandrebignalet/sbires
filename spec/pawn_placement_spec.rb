RSpec.describe Sbires do
  let(:player_names) { %w(Jean Francois) }

  before do
    players = Game.prepare_players(player_names)
    @game = Game.new(players)
    @players = @game.players
    @player_one = @players.first
    @player_two = @players.last

    @first_player = @game.current_player
    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
  end

  it "game should not allow a player to place multiple pawns consecutively" do
    expect { @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU) }.to raise_error Sbires::Error
  end

  it "after pawn placement player should pick a card on its neighbour" do
    expect(@first_player.cards.length).to eq 1
    expect(@first_player.cards.first.neighbour_name).to eq NeighbourType::CHATEAU

    neighbour = @game.neighbours.detect { |n| n.name == NeighbourType::CHATEAU }
    expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
    expect(neighbour.discard.length).to eq 0
  end

  context "end of placement phase" do
    before do
      @second_player = @players.detect { |p| p.lord_name == @game.current_player.lord_name }
      @first_player = @players.detect { |p| p.lord_name != @second_player.lord_name }

      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
      @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)

      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
      @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)

      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
      @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)

      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
      @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
      @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
      @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)

      @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
      @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)
    end

    it "should know when each player has placed all of its pawns" do
      expect(@game.first_phase_over?).to be true
    end

    it "should be in phase 2" do
      expect(@game.state).to be_instance_of PlayCards
    end

    it "should give one more card from a neighbour to player with domination its neighbour" do
      expect(@second_player.cards.length).to eq 9
      eglise_cards = @second_player.cards.select { |c| c.neighbour_name == NeighbourType::EGLISE }
      expect(eglise_cards.length).to eq 5
      expect(@first_player.cards.length).to eq 9
      chateau_cards = @first_player.cards.select { |c| c.neighbour_name == NeighbourType::CHATEAU }
      expect(chateau_cards.length).to eq 5
    end
  end
end