RSpec.describe PlayHandlers::MontreurDours do
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

  it "should raise if targetted player not found" do
    expect { @game.draw_card(@first_player.lord_name, 
                    CardType::MONTREUR_DOURS, 
                    target_card: CardType::DEMONSTRATION_AMUSEUR, 
                    target_player: Game::LORD_NAMES.last) }.to raise_error Sbires::Error
  end

  it "should raise if targetted player is current player" do
    expect { @game.draw_card(@first_player.lord_name,
                             CardType::MONTREUR_DOURS,
                             target_card: CardType::DEMONSTRATION_AMUSEUR,
                             target_player: @first_player.lord_name) }.to raise_error Sbires::Error
  end

  it "should raise if targetted card is not a Demonstration card" do

    expect { @game.draw_card(@first_player.lord_name,
                             CardType::MONTREUR_DOURS,
                             target_card: CardType::CRIEUR_PUBLIC,
                             target_player: @second_player.lord_name) }.to raise_error Sbires::Error
  end

  it "should raise if targetted player does not have targetted card in spare" do
    expect { @game.draw_card(@first_player.lord_name,
                             CardType::MONTREUR_DOURS,
                             target_card: CardType::DEMONSTRATION_AMUSEUR,
                             target_player: @second_player.lord_name) }.to raise_error Sbires::Error
  end

  describe "when play is correct" do
    let(:chateau_neighbour) { @game.find_neighbour(NeighbourType::CHATEAU) }

    before do
      @init_discard_size = chateau_neighbour.discard.size
      @init_player_cards_count = @first_player.cards.size

      @second_player.spare << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)

      @first_player.cards << Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)
      @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)

      @second_player.cards << Card.new(@second_player.lord_name, CardType::VAILLANCE)
      @game.draw_card(@second_player.lord_name, CardType::VAILLANCE)

      @game.draw_card(@first_player.lord_name,
                      CardType::MONTREUR_DOURS,
                      target_card: CardType::DEMONSTRATION_AMUSEUR,
                      target_player: @second_player.lord_name)
    end

    it "should place the game in parryable attack state" do
      expect(@game.state).to be_instance_of ParryableAttackState
    end

    context  "when the play is not countered" do
      before do
        @game.do_not_protect(@second_player.lord_name)
      end

      it "should place the target player targetted demonstration card in the neighbour discard" do
        actual_discard_size = chateau_neighbour.discard.count

        expect(actual_discard_size).to eq(@init_discard_size + 2)
      end

      it "should discard the played card after usage" do
        actual_player_cards_count = @first_player.cards.size
        expect(actual_player_cards_count).to eq(@init_player_cards_count - 1)
      end

      it "should end current player turn" do
        expect(@game.current_player).to eq(@second_player)
      end
    end

    context "when the play is countered" do
      before do
        @game.use_card_effect(@second_player.lord_name, CardType::VAILLANCE)
      end

      it "should not affect targetted player" do
        expect(@second_player.spare.map(&:name)).to include(CardType::DEMONSTRATION_AMUSEUR)
      end

      it "should have ended player turn" do
        expect(@game.current_player).to eq(@second_player)
      end
    end
  end
end