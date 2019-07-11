require 'pry-byebug'

RSpec.describe "Card play phase" do

  before do
    player_names = ["Alex", "Yoan"]
    @game = Game.new(player_names)
    @current_player = @game.current_player
    @players = @game.players
  end

  it "should raise if player try to put a card in phase 1" do
    play = Play.new(@current_player.lord_name, CardType::DEMONSTRATION_MENESTREL)
    expect { @game.draw_card(play) }.to raise_error Sbires::Error
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
      play = Play.new(@first_player.lord_name, CardType::DEMONSTRATION_AMUSEUR)
      expect { @game.draw_card(play) }.to raise_error Sbires::Error
    end

    it "should have lost a card in hand" do
      initial_card_number = @first_player.cards.length
      play = Play.new(@first_player.lord_name, CardType::DEMONSTRATION_MENESTREL)
      @game.draw_card(play)

      expect(@first_player.cards.length).to eq initial_card_number - 1
    end

    context "Démonstration card played" do
      it "should put Démonstration cards in player's spare" do
        play = Play.new(@first_player.lord_name, CardType::DEMONSTRATION_MENESTREL)
        @game.draw_card(play)

        expect(@first_player.spare.first.name).to eq CardType::DEMONSTRATION_MENESTREL
        expect(@game.current_player).not_to be @first_player
      end
    end

    context "Fossoyeur card played" do
      it "should raise if card to pick is not in discard" do
        play = PlayFossoyeur.new(@first_player.lord_name, NeighbourType::CHATEAU, CardType::FOSSOYEUR)
        expect { @game.draw_card(play) }.to raise_error Sbires::Error
      end

      it "should pick the asked card in the asked discard" do
        card_name = CardType::DEMONSTRATION_MENESTREL
        neighbour_name = NeighbourType::CHATEAU
        targeted_neighbour = @game.find_neighbour neighbour_name
        @first_player.discard_in(card_name, targeted_neighbour)

        initial_discard_size = targeted_neighbour.discard.length
        initial_player_card_number = @first_player.cards.length

        play = PlayFossoyeur.new(@first_player.lord_name, neighbour_name, card_name)
        @game.draw_card(play)

        expect(@first_player.cards.length).to eq initial_player_card_number + 1
        expect(targeted_neighbour.discard.length).to eq initial_discard_size - 1
        expect(@game.current_player).not_to be @first_player
      end
    end

    context "Crieur public card played" do
      it "should receive a card of each neighbour where player is dominant" do
        initial_card_number = @first_player.cards.length
        play = Play.new(@first_player.lord_name, CardType::CRIEUR_PUBLIC)
        @game.draw_card(play)

        # 2 dominations - 1 discarded card = base + 1
        expect(@first_player.cards.length).to eq initial_card_number + 1
        expect(@first_player.cards.last.name).to eq CardType::CRIEUR_PUBLIC
      end
    end

    # create base play handler for end turn card or middleware
    #
    # make player play the card -> in order to resolve the card before the use case
    # this way we have the neighbour name (implicitely)
    #
    # create double for deck factory in order to test against a specific deck
    # and to introduce real card repartition
  end
end