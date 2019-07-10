require 'pry'

module Sbires
  RSpec.describe Sbires do
    let(:player_names) { %w(Jean Francois) }

    it "should not be launch with less than 2 player or more than 5" do
      expect { Game.new([]) }.to raise_error Error
      expect { Game.new(["player1"]) }.to raise_error Error
      expect { Game.new(%w(player1 player2 player3 player4 player5 player6)) }.to raise_error Error
    end

    context "game start" do

      before do
        @game = Game.new(player_names)
        @players = @game.players
        @player_one = @players.first
        @player_two = @players.last
      end

      it "should be in phase 1" do
        expect(@game.current_phase).to eq 1
      end

      it "game should create players" do
        expect(@players.map(&:name)).to eq(player_names)
      end

      it "game should elect the first player" do
        expect(@game.current_player).not_to be nil
        expect(@players.map(&:lord_name)).to include(@game.current_player.lord_name)
      end

      it "game should assign a lord name for each players" do
        expect(LORD_NAMES).to include(@player_one.lord_name)
        expect(LORD_NAMES).to include(@player_two.lord_name)
      end

      it "game should give 5 points for each players" do
        expect(@player_one.points).to eq 5
        expect(@player_two.points).to eq 5
      end
    end

    context "Neighbour" do

      it "a player should be allowed to place pawn on a neighbour" do
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 2)
        player = Player.new("Jean", LORD_NAMES.first)

        player.place_pawn_on(neighbour)

        expect(neighbour.full?).to be false
        expect(player.pawns.length).to be Player::PAWN_PER_PLAYER - 1
      end

      it "should raise when player has no more pawns to place" do
        chateau = Neighbour.new(NEIGHBOURS_NAMES.first, 3)
        taverne = Neighbour.new(NEIGHBOURS_NAMES[1], 3)
        player = Player.new("Jean", LORD_NAMES.first)

        player.place_pawn_on(chateau)
        player.place_pawn_on(chateau)
        player.place_pawn_on(chateau)
        player.place_pawn_on(chateau)
        player.place_pawn_on(taverne)
        player.place_pawn_on(taverne)
        player.place_pawn_on(taverne)
        player.place_pawn_on(taverne)

        expect { player.place_pawn_on(taverne) }.to raise_error Error
      end

      it "neighbour should be full with 4 pawns when 2 players in game" do
        player = Player.new("Jean", LORD_NAMES.first)
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 2)

        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)

        expect(neighbour.full?).to be true
      end

      it "neighbour should raise if player try to put a pawn on a full neighbour" do
        player = Player.new("Jean", LORD_NAMES.first)
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 2)

        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        expect { player.place_pawn_on(neighbour) }.to raise_error Error
      end

      it "neighbour should be full with 5 pawns when 3 players in game" do
        player = Player.new("Jean", LORD_NAMES.first)
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 3)

        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)
        player.place_pawn_on(neighbour)

        expect(neighbour.full?).to be true
      end

      it "should create a deck with 26 cards of the neighbour name" do
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 3)

        expect(neighbour.deck).to all( have_attributes neighbour_name: neighbour.name )
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR
      end

      it "should create an empty discard on init" do
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 3)

        expect(neighbour.discard.length).to eq 0
      end

      it "should allow player to shift a card of the deck" do
        player = Player.new("Jean", LORD_NAMES.first)
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 3)

        player.pick_card_from(neighbour)

        expect(player.cards.length).to eq 1
        expect(player.cards.first).to have_attributes neighbour_name: neighbour.name
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
      end

      it "should allow player to discard a card" do
        player = Player.new("Jean", LORD_NAMES.first)
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 3)

        player.pick_card_from(neighbour)
        player.discard_in(player.cards.first, neighbour)

        expect(player.cards.length).to eq 0
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
        expect(neighbour.discard.length).to eq 1
      end

      it "should raise if discarded card does not belong to the player" do
        player = Player.new("Jean", LORD_NAMES.first)
        player2 = Player.new("Mich", LORD_NAMES[2])
        neighbour = Neighbour.new(NEIGHBOURS_NAMES.sample, 3)

        player2.pick_card_from(neighbour)
        expect { player.discard_in(player2.cards.first, neighbour) }.to raise_error Error
      end
    end


    context "Game pawn placement" do
      before do
        @game = Game.new(player_names)
        @players = @game.players
        @player_one = @players.first
        @player_two = @players.last

        @chateau = NEIGHBOURS_NAMES.first
        @first_player = @game.current_player
        @game.place_pawn(@first_player.lord_name, @chateau)
      end

      it "game should not allow a player to place multiple pawns consecutively" do
        expect { @game.place_pawn(@first_player.lord_name, NEIGHBOURS_NAMES.first) }.to raise_error Error
      end

      it "after pawn placement player should pick a card on its neighbour" do
        expect(@first_player.cards.length).to eq 1
        expect(@first_player.cards.first.neighbour_name).to eq NEIGHBOURS_NAMES.first

        neighbour = @game.neighbours.detect { |n| n.name == NEIGHBOURS_NAMES.first }
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
        expect(neighbour.discard.length).to eq 0
      end

      context "end of placement phase" do
        before do
          @second_player = @players.detect { |p| p.lord_name == @game.current_player.lord_name }
          @first_player = @players.detect { |p| p.lord_name != @second_player.lord_name }

          @eglise = NEIGHBOURS_NAMES.last
          @taverne = NEIGHBOURS_NAMES.first(2).last
          @salle_d_armes = NEIGHBOURS_NAMES.first(3).last

          @game.place_pawn(@second_player.lord_name, @eglise)
          @game.place_pawn(@first_player.lord_name, @chateau)

          @game.place_pawn(@second_player.lord_name, @eglise)
          @game.place_pawn(@first_player.lord_name, @chateau)

          @game.place_pawn(@second_player.lord_name, @eglise)
          @game.place_pawn(@first_player.lord_name, @chateau)

          @game.place_pawn(@second_player.lord_name, @eglise)

          @game.place_pawn(@first_player.lord_name, @taverne)
          @game.place_pawn(@second_player.lord_name, @taverne)

          @game.place_pawn(@first_player.lord_name, @taverne)
          @game.place_pawn(@second_player.lord_name, @taverne)

          @game.place_pawn(@first_player.lord_name, @salle_d_armes)
          @game.place_pawn(@second_player.lord_name, @salle_d_armes)

          @game.place_pawn(@first_player.lord_name, @salle_d_armes)
          @game.place_pawn(@second_player.lord_name, @salle_d_armes)
        end

        it "should know when each player has placed all of its pawns" do
          expect(@game.first_phase_over?).to be true
        end

        it "should be in phase 2" do
          expect(@game.current_phase).to eq 2
        end

        it "should give one more card from a neighbour to player with domination its neighbour" do
          expect(@second_player.cards.length).to eq 9
          eglise_cards = @second_player.cards.select { |c| c.neighbour_name == @eglise }
          expect(eglise_cards.length).to eq 5
          expect(@first_player.cards.length).to eq 9
          chateau_cards = @first_player.cards.select { |c| c.neighbour_name == @chateau }
          expect(chateau_cards.length).to eq 5
        end
      end
    end
  end
end