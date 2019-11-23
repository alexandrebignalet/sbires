RSpec.describe PlayHandlers::Vaillance do
  VAILLANCE_CARD = CardType::VAILLANCE

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
      @first_player.cards << Card.new(NeighbourType::GRAND_PLACE, VAILLANCE_CARD, used: false)
      @game.draw_card(@first_player.lord_name, VAILLANCE_CARD)
    end

    it "should give player an atout" do
       expect(@first_player.atout.name).to eq(VAILLANCE_CARD)
    end

    it "should have end the player turn" do
      expect(@game.current_player).to be @second_player
    end

    it "should let player resolve the atout drawn from spare" do
      atout = @first_player.find_card_in_spare(VAILLANCE_CARD)
      expect(atout).to eq(@first_player.atout)
    end
  end

  context "when Vaillance is used" do
    before do
      @first_player.cards << Card.new(NeighbourType::GRAND_PLACE, VAILLANCE_CARD, used: false)

      @game.draw_card(@first_player.lord_name, VAILLANCE_CARD)

      @second_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)
      @game.draw_card(@second_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)

      @first_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)
      @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)
    end

    context "when Vaillance is not used in ParryableAttackState" do
      before do
        @second_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE)
        @game.draw_card(@second_player.lord_name, CardType::DEMONSTRATION_FABULISTE)
      end

      it "should raise" do
        expect { @game.use_card_effect(@first_player.lord_name, VAILLANCE_CARD) }.to raise_error Sbires::Error
      end
    end

    context "when Vaillance is used to protect against an attack on his hand or on his spare (when game is in ParryableAttackState)" do
      let(:target_card) { CardType::DEMONSTRATION_AMUSEUR }

      before do
        @second_player.cards << Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS)
        @game.draw_card(@second_player.lord_name, CardType::MONTREUR_DOURS, target_card: target_card, target_player: @first_player.lord_name)
      end

      context 'not used yet' do
        it "should not have atout used if the card has not be used" do
          expect(@first_player.atout.used?).to be false
        end
      end

      context "card used" do
        before do
          @game.use_card_effect(@first_player.lord_name, VAILLANCE_CARD)
        end

        it "should set atout to used" do
          expect(@first_player.atout.used?).to be true
        end

        it "should not have affected the target player" do
          expect(@first_player.spare.map(&:name)).to include target_card
        end
      end
    end
  end
end