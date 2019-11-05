RSpec.describe "Demonstration card played" do
  before do
    start_two_players_game(
        DeckFactoryMock.with_the_three_demonstrations,
        [
            NeighbourType::CHATEAU,
            NeighbourType::CHATEAU,
            NeighbourType::CHATEAU,
            NeighbourType::EGLISE,
            NeighbourType::CHATEAU,
            NeighbourType::EGLISE,
            NeighbourType::GRAND_PLACE,
            NeighbourType::GRAND_PLACE,
            NeighbourType::GRAND_PLACE,
            NeighbourType::GRAND_PLACE,
            NeighbourType::TAVERNE,
            NeighbourType::TAVERNE,
            NeighbourType::TAVERNE,
            NeighbourType::TAVERNE,
            NeighbourType::EGLISE,
            NeighbourType::EGLISE
        ])
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
end