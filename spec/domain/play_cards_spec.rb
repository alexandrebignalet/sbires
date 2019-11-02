RSpec.describe "Card play phase" do

  before do
    allow_any_instance_of(DeckFactory).to receive(:factories).and_return(DeckFactoryMock.unique_card_neighbour)

    players = Game.prepare_players(%w(Alex Yoan))
    @game = Game.new(players)
    @current_player = @game.current_player
    @players = @game.players
  end

  it "should raise if player try to put a card in phase 1" do
    expect { @game.draw_card(@current_player.lord_name, CardType::DEMONSTRATION_MENESTREL) }.to raise_error Sbires::Error
  end

  context "when the game is in phase Play Cards" do
    before do
      @first_player = @players.detect { |p| p.lord_name == @current_player.lord_name }
      @second_player = @players.detect { |p| p.lord_name != @first_player.lord_name }

      @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::EGLISE)
      @game.place_pawn(@second_player.lord_name, NeighbourType::CHATEAU)

      @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
      @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
      @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
      @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)

      @game.place_pawn(@first_player.lord_name, NeighbourType::GRAND_PLACE)
      @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)

      @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
      @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)
    end

    it "should raise if player does not own the card" do
      expect { @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR) }.to raise_error Sbires::Error
    end

    it "should raise if not player's turn" do
      expect { @game.draw_card(@second_player.lord_name, CardType::DEMONSTRATION_MENESTREL)}.to raise_error Sbires::Error
    end

    it "should have lost a card in hand" do
      initial_card_number = @first_player.cards.length
      @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_MENESTREL)

      expect(@first_player.cards.length).to eq initial_card_number - 1
    end

    context "Démonstration card played" do
      it "should put Démonstration cards in player's spare" do
        @game.draw_card(@first_player.lord_name, CardType::DEMONSTRATION_MENESTREL)

        expect(@first_player.spare.first.name).to eq CardType::DEMONSTRATION_MENESTREL
        expect(@game.current_player).not_to be @first_player
      end
    end

    context "Fossoyeur card played" do
      it "should raise if card to pick is not in discard" do
        expect { @game.draw_card(@first_player.lord_name, CardType::FOSSOYEUR, { neighbour_discard: NeighbourType::CHATEAU, chosen_card_name: CardType::FOSSOYEUR })  }.to raise_error Sbires::Error
      end

      it "should pick the asked card in the asked discard" do
        card_name = CardType::DEMONSTRATION_MENESTREL
        neighbour_name = NeighbourType::CHATEAU
        targeted_card = @first_player.find_card card_name
        targeted_neighbour = @game.find_neighbour neighbour_name
        @first_player.discard_in(targeted_card, targeted_neighbour)

        initial_discard_size = targeted_neighbour.discard.length
        initial_player_card_number = @first_player.cards.length

        @game.draw_card(@first_player.lord_name, CardType::FOSSOYEUR, { neighbour_discard: neighbour_name, chosen_card_name: card_name })

        expect(@first_player.cards.length).to eq initial_player_card_number + 1
        expect(targeted_neighbour.discard.length).to eq initial_discard_size - 1
        expect(@game.current_player).not_to eq @first_player
      end
    end

    context "Crieur public card played" do
      it "should receive a card of each neighbour where player is dominant" do
        initial_card_number = @first_player.cards.length
        @game.draw_card(@first_player.lord_name, CardType::CRIEUR_PUBLIC)

        # 2 dominations - 1 discarded card = base + 1
        expect(@first_player.cards.length).to eq initial_card_number + 1
        expect(@first_player.cards.last.name).to eq CardType::CRIEUR_PUBLIC
      end
    end

    context "Bagarre générale card played: " do
      context "every player except current must send a spare card in his discard" do
        before do
          # put a card in spare of second player
          @discardable_card_name = CardType::DEMONSTRATION_MENESTREL
          @discardable_card = @second_player.find_card @discardable_card_name
          @second_player.spare_card(@discardable_card)

          @game.draw_card(@first_player.lord_name, CardType::BAGARRE_GENERALE)
        end

        it "should set game in bagarre générale mode" do
          expect(@game.state).to be_instance_of BagarreGeneraleState
        end

        it "should not have ended current player turn" do
          expect(@first_player).to eq @game.current_player
        end

        it "should allow other player to discard one of their spare cards" do
          initial_spare_size = @second_player.spare.length
          @game.discard_spare_card(@second_player.lord_name, @discardable_card_name)

          expect(@second_player.spare.length).to eq initial_spare_size - 1
        end

        it "should raise if the given card is not in spare" do
          expect { @game.discard_spare_card(@second_player.lord_name, CardType::ARMURE_COMPLETE) }.to raise_error Sbires::Error
        end

        # when player has no spare card
        it "should end current player turn when every other have discarded a spare card" do
          @game.discard_spare_card(@second_player.lord_name, @discardable_card_name)

          expect(@game.state).to be_instance_of PlayCards
          expect(@game.current_player).not_to eq @first_player
        end
      end

      context "when nobody is discardable" do
        before do
          @game.draw_card(@first_player.lord_name, CardType::BAGARRE_GENERALE)
        end

        it "should end current player turn and regret his miss play" do
          expect(@game.state).to be_instance_of PlayCards
          expect(@game.current_player).not_to eq @first_player
        end
      end
    end

    context "armure complete card played" do
      it "should raise if we are not in duel" do
        expect { @game.draw_card(@first_player.lord_name, CardType::ARMURE_COMPLETE) }.to raise_error Sbires::Error
      end
    end
  end
end