RSpec.describe "End of day" do
  before do
    deck_factory = DeckFactory.new
    allow(deck_factory).to receive(:factories).and_return DeckFactoryMock.duel_deck
    players = Game.prepare_players(%w(jean francois michel))
    @game = Game.new(players, neighbours: Game.prepare_neighbours(players.length, deck_factory))
    set_three_players
  end

  it "should not end the day for any player until all pawns placed" do
    expect { @game.end_day_for @first_player }.to raise_error Sbires::Error
    expect { @game.end_day_for @second_player }.to raise_error Sbires::Error
    expect { @game.end_day_for @third_player }.to raise_error Sbires::Error
  end

  context "after first day pawn placement done" do
    before do
      pawn_placement
    end

    it "should allow any player and whenever they want to skip their turn during play cards phase" do
      @game.end_day_for @first_player

      expect(@game.current_player).to eq @second_player
    end

    it "should not allow player to end his day if not his turn to speak" do
      expect { @game.end_day_for @second_player }.to raise_error Sbires::Error
    end

    it "should not allow skippers to play again during the day" do
      @game.end_day_for @first_player

      @game.draw_card(@second_player.lord_name, CardType::PRIERE)

      expect(@game.current_player).to eq @second_player
    end

    context 'transition to the next day' do
      before do
        @game.end_day_for @first_player
        @game.end_day_for @second_player
        @game.end_day_for @third_player

        set_three_players
      end

      it "should go to the next day if every player ended theirs" do
        expect(@game.current_day).to eq(2)
      end

      it "should have cleared all players hands" do
        expect(@first_player.cards.empty?).to be true
        expect(@second_player.cards.empty?).to be true
        expect(@third_player.cards.empty?).to be true
      end

      it "should have reset neighbours deck/discard/pawns" do
        @game.neighbours.each do |n|
          expect(n.deck.size).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR
          expect(n.discard.empty?).to be true
          expect(n.full?).to be false
        end
      end

      it "should start the new day by a pawn placement" do
        expect(@game.state).to be_instance_of PawnPlacement
      end

      it "should reset turn skippers" do
        expect(@game.turn_skippers.empty?).to be true
      end
    end
  end


  def pawn_placement
    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@third_player.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@third_player.lord_name, NeighbourType::CHATEAU)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::TAVERNE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::TAVERNE)
  end

  def set_three_players
    @first_player = @game.current_player
    @second_player = @game.players[@game.next_player_index]
    @third_player = @game.players.detect { |p| p != @first_player && p != @second_player }
  end
end