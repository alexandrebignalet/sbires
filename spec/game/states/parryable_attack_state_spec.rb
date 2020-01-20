RSpec.describe ParryableAttackState do

  before do
    start_two_players_game(DeckFactoryMock.random_deck)
  end

  it "should raise if 'do not protect' outside a parryable attack state" do
    expect { @game.do_not_protect(@first_player.lord_name) }.to raise_error Sbires::Error
  end

  describe "when a parryable card is played" do
    let(:played_card) { CardType::MONTREUR_DOURS }
    let(:target_card_type) { CardType::DEMONSTRATION_AMUSEUR }

    before do
      @second_player.cards << Card.new(NeighbourType::GRAND_PLACE, CardType::VAILLANCE, used: false)

      @second_player.spare << Card.new(NeighbourType::CHATEAU, target_card_type)
      @first_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE)
      @first_player.cards << Card.new(NeighbourType::CHATEAU, played_card, parried_by: [])

      @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_FABULISTE)
      @game.draw_card(@second_player.lord_name, CardType::VAILLANCE)

      @game.draw_card(@first_player.lord_name,
                      played_card,
                      target_card: target_card_type,
                      target_player: @second_player.lord_name)
    end

    it "should set the game in parryable attack state" do
      expect(@game.state).to be_instance_of ParryableAttackState
    end

    it "should have a target player" do
      expect(@game.state.target_player).to eq(@second_player)
    end

    it "should have a attack card" do
      expect(@game.state.attack_card.name).to eq(played_card)
    end

    it "should raise if any player draws a card" do
      expect { @game.draw_card(@first_player.lord_name,
                               CardType::MONTREUR_DOURS,
                               target_card: CardType::DEMONSTRATION_AMUSEUR,
                               target_player: @second_player.lord_name) }.to raise_error Sbires::Error

      expect { @game.draw_card(@second_player.lord_name,
                               CardType::MONTREUR_DOURS,
                               target_card: CardType::DEMONSTRATION_AMUSEUR,
                               target_player: @second_player.lord_name) }.to raise_error Sbires::Error
    end

    it "should raise if any player other than targeted 'do not protect'" do
      expect { @game.do_not_protect(@first_player.lord_name) }.to raise_error Sbires::Error
    end

    context "when the target do not protect" do
      before do
        @game.do_not_protect(@second_player.lord_name)
      end

      it "should apply the effect" do
        expect(@second_player.spare.map(&:name)).to_not include target_card_type
      end

      it "go back to play cards state" do
        expect(@game.state).to be_instance_of PlayCards
      end
    end

    describe "when target player protects using a card effect" do
      before do
        @game.use_card_effect(@second_player.lord_name, CardType::VAILLANCE)
      end

      it "should not have applied the card attacker effect" do
        expect(@second_player.spare.map(&:name)).to include target_card_type
      end

      it "should went back to PlayCards state" do
        expect(@game.state).to be_instance_of PlayCards
      end

      describe "when the player wants to use a card twice in a day" do
        before do
          @second_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE)
          @game.draw_card(@second_player.lord_name, CardType::DEMONSTRATION_FABULISTE)

          @first_player.cards << Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS)
          @game.draw_card(@first_player.lord_name, CardType::MONTREUR_DOURS, target_card: CardType::DEMONSTRATION_AMUSEUR, target_player: @second_player.lord_name)
        end

        it "should not use twice a card effect during a day" do
          expect { @game.use_card_effect(@second_player.lord_name, CardType::VAILLANCE) }.to raise_error Sbires::Error
        end

      end
    end

    describe "when target player wants to protect him discarding a counter card" do

      it "should raise if anyone else than target player discards" do
        expect {
          @game.discard_spare_card(@first_player.lord_name, CardType::MONTREUR_DOURS)
        }.to raise_error Sbires::Error
      end

      it "should raise if the card chosen is not owned by target player" do
        @second_player.spare.clear

        expect {
          @game.discard_spare_card(@second_player.lord_name, CardType::MONTREUR_DOURS)
        }.to raise_error Sbires::Error
      end

      it "should raise if the used card cannot protect him" do
        @second_player.spare << Card.new(NeighbourType::EGLISE, CardType::PENITENT)

        expect {
          @game.discard_spare_card(@second_player.lord_name, CardType::PENITENT)
        }.to raise_error Sbires::Error
      end
    end
  end
end