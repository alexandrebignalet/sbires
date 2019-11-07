RSpec.describe PlayHandlers::Vaillance do

  before do
    start_two_players_game(
        DeckFactoryMock.card_on_top(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS),
        [
            NeighbourType::CHATEAU,
            NeighbourType::SALLE_D_ARMES,
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

  context "when card is placed in spare" do
    before do
      @first_player.cards << Card.new(NeighbourType::GRAND_PLACE, CardType::VAILLANCE)
      @game.draw_card(@first_player.lord_name, CardType::VAILLANCE)
    end

    it "should give player an atout" do
       expect(@first_player.atout.name).to eq(CardType::VAILLANCE)
    end

    it "should have end the player turn" do
      expect(@game.current_player).to be @second_player
    end
  end

  context "when card can be tapped to protect against an attack on his hand or on his spare" do
    before do
      @first_player.cards << Card.new(NeighbourType::GRAND_PLACE, CardType::VAILLANCE)

      @game.draw_card(@first_player.lord_name, CardType::VAILLANCE, target_card: target_card, target_player: @second_player)

      @second_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)
      @game.draw_card(@second_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)

      @first_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)
      @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)

      @second_player.cards << Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS)
      @game.draw_card(@second_player.lord_name, CardType::MONTREUR_DOURS, target_card: CardType::DEMONSTRATION_AMUSEUR, target_player: @first_player)

      @game.tap_card(@first_player.lord_name, CardType::VAILLANCE)
    end

    it "should set atout to tapped" do
      expect(@first_player.atout.tapped?).to be true
    end
  end
end