require 'pry'

module Sbires
  RSpec.describe Sbires do
    let(:player_names) { %w(Jean Francois) }

    context "Game pawn placement" do
      before do
        @game = Game.new(player_names)
        @players = @game.players
        @player_one = @players.first
        @player_two = @players.last

        @chateau = Game::NEIGHBOURS_NAMES.first
        @first_player = @game.current_player
        @game.place_pawn(@first_player.lord_name, @chateau)
      end

      it "game should not allow a player to place multiple pawns consecutively" do
        expect { @game.place_pawn(@first_player.lord_name, Game::NEIGHBOURS_NAMES.first) }.to raise_error Sbires::Error
      end

      it "after pawn placement player should pick a card on its neighbour" do
        expect(@first_player.cards.length).to eq 1
        expect(@first_player.cards.first.neighbour_name).to eq Game::NEIGHBOURS_NAMES.first

        neighbour = @game.neighbours.detect { |n| n.name == Game::NEIGHBOURS_NAMES.first }
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
        expect(neighbour.discard.length).to eq 0
      end

      context "end of placement phase" do
        before do
          @second_player = @players.detect { |p| p.lord_name == @game.current_player.lord_name }
          @first_player = @players.detect { |p| p.lord_name != @second_player.lord_name }

          @eglise = Game::NEIGHBOURS_NAMES.last
          @taverne = Game::NEIGHBOURS_NAMES.first(2).last
          @salle_d_armes = Game::NEIGHBOURS_NAMES.first(3).last

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