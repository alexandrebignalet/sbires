require 'pry-byebug'
require_relative './mocks/deck_factory_mock'

RSpec.describe "Card play phase" do

  before do
    player_names = ["Alex", "Yoan"]
    @game = Game.new(player_names)
    @current_player = @game.current_player
    @players = @game.players
  end

  it "should raise if player try to put a card in phase 1" do
    expect { @game.draw_card(@current_player.lord_name, CardType::DEMONSTRATION_MENESTREL) }.to raise_error Sbires::Error
  end

  context "when the game is in phase Play Cards" do
    before do
      allow_any_instance_of(DeckFactory).to receive(:create_deck_for).and_return(DeckFactoryMock.unique_card_neighbour)

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
        expect(@game.current_player).not_to be @first_player
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
  end
end