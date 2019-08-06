RSpec.describe "End of day" do
  before do
    allow_any_instance_of(DeckFactory).to receive(:deck_by_neighbour).and_return DeckFactoryMock.duel_deck
    players = Game.prepare_players(%w(jean francois michel))
    @game = Game.new(players)
    @first_player = @game.current_player
    @second_player = @game.players[@game.next_player_index]
    @third_player = @game.players.detect { |p| p != @first_player && p != @second_player }
  end

  it "should not end the day for any player until all pawns placed" do
    expect { @game.end_day_for @first_player }.to raise_error Sbires::Error
    expect { @game.end_day_for @second_player }.to raise_error Sbires::Error
    expect { @game.end_day_for @third_player }.to raise_error Sbires::Error
  end

  context "after pawn placement done" do

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
end