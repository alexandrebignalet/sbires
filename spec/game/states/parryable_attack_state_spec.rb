RSpec.describe ParryableAttackState do

  before do
    start_two_players_game(DeckFactoryMock.random_deck)
  end
  describe "when a parryable card is played" do
    let(:played_card) { CardType::MONTREUR_DOURS }
    let(:target_card_type) { CardType::DEMONSTRATION_AMUSEUR }

    before do
      @second_player.spare << Card.new(NeighbourType::CHATEAU, target_card_type)
      @first_player.cards << Card.new(NeighbourType::CHATEAU, played_card, parried_by: [])

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

      # TODO it should also be parried by
    end
  end
end