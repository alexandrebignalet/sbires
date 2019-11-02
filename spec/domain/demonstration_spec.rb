RSpec.describe "Demonstration card played" do
  before do
    allow_any_instance_of(DeckFactory).to receive(:factories).and_return(DeckFactoryMock.with_the_three_demonstrations)
    players = Game.prepare_players(%w(jean francois))
    @game = Game.new(players)
    @first_player = @game.current_player
    @second_player = @game.players.detect { |p| p != @first_player }

    pawn_placement
  end

  it "should add menestrel to his spare" do
    @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_MENESTREL)

    expect(@first_player.spare.first.name).to eq CardType::DEMONSTRATION_MENESTREL
  end

  it "should add amuseur to his spare" do
    @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)

    expect(@first_player.spare.first.name).to eq CardType::DEMONSTRATION_AMUSEUR
  end

  it "should add fabuliste to his spare" do
    @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_FABULISTE)

    expect(@first_player.spare.first.name).to eq CardType::DEMONSTRATION_FABULISTE
  end

  it "should not have more than 3 demonstration in spare" do
    @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_FABULISTE)
    @game.draw_card(@second_player.lord_name, CardType::DEMONSTRATION_MENESTREL)

    @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_MENESTREL)
    @game.draw_card(@second_player.lord_name, CardType::CRIEUR_PUBLIC)

    @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)
    @game.draw_card(@second_player.lord_name, CardType::CRIEUR_PUBLIC)

    expect { @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR) }.to raise_error Sbires::Error

  end

  def pawn_placement
    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::CHATEAU)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)
  end
end