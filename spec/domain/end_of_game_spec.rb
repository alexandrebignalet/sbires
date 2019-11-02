RSpec.describe "End of game" do
  before do
    allow_any_instance_of(DeckFactory).to receive(:factories).and_return DeckFactoryMock.duel_deck
    players = Game.prepare_players(%w(jean francois))
    @game = Game.new(players)
    @first_player = @game.current_player
    @second_player = @game.players[@game.next_player_index]
  end



  it "should end the game after day four" do
    pawn_placement

    @game.end_day_for @first_player
    @game.end_day_for @second_player

    pawn_placement

    @game.end_day_for @first_player
    @game.end_day_for @second_player

    pawn_placement

    @game.end_day_for @first_player
    @game.end_day_for @second_player

    pawn_placement

    @game.end_day_for @first_player
    @game.end_day_for @second_player

    expect(@game.current_day).to be 4
  end

  def pawn_placement
    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)
  end
end