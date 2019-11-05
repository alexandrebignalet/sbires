module Sbires
  RSpec.describe Neighbour do

    it "a player should be allowed to place pawn on a neighbour" do
      neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 2)
      player = Player.new("Jean", Game::LORD_NAMES.first)

      player.place_pawn_on(neighbour)

      expect(neighbour.full?).to be false
      expect(player.pawns.length).to be Player::PAWN_PER_PLAYER - 1
    end

    it "should raise when player has no more pawns to place" do
      chateau = Neighbour.new(Game::NEIGHBOURS_NAMES.first, 3)
      taverne = Neighbour.new(Game::NEIGHBOURS_NAMES[1], 3)
      player = Player.new("Jean", Game::LORD_NAMES.first)

      player.place_pawn_on(chateau)
      player.place_pawn_on(chateau)
      player.place_pawn_on(chateau)
      player.place_pawn_on(chateau)
      player.place_pawn_on(taverne)
      player.place_pawn_on(taverne)
      player.place_pawn_on(taverne)
      player.place_pawn_on(taverne)

      expect { player.place_pawn_on(taverne) }.to raise_error Sbires::Error
    end

    it "neighbour should be full with 4 pawns when 2 players in game" do
      player = Player.new("Jean", Game::LORD_NAMES.first)
      neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 2)

      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)

      expect(neighbour.full?).to be true
    end

    it "neighbour should raise if player try to put a pawn on a full neighbour" do
      player = Player.new("Jean", Game::LORD_NAMES.first)
      neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 2)

      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      expect { player.place_pawn_on(neighbour) }.to raise_error Sbires::Error
    end

    it "neighbour should be full with 5 pawns when 3 players in game" do
      player = Player.new("Jean", Game::LORD_NAMES.first)
      neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 3)

      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)
      player.place_pawn_on(neighbour)

      expect(neighbour.full?).to be true
    end

    context "Card assignation" do
      it "should create a deck with 26 cards of the neighbour name" do
        neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 3)

        expect(neighbour.deck).to all( have_attributes neighbour_name: neighbour.name )
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR
      end

      it "should create an empty discard on init" do
        neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 3)

        expect(neighbour.discard.length).to eq 0
      end

      it "should allow player to shift a card of the deck" do
        player = Player.new("Jean", Game::LORD_NAMES.first)
        neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 3)

        player.pick_top_card_of_deck(neighbour)

        expect(player.cards.length).to eq 1
        expect(player.cards.first).to have_attributes neighbour_name: neighbour.name
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
      end

      it "should allow player to discard a card" do
        player = Player.new("Jean", Game::LORD_NAMES.first)
        neighbour = Neighbour.new(Game::NEIGHBOURS_NAMES.sample, 3)

        player.pick_top_card_of_deck(neighbour)
        player.discard_in(player.cards.first, neighbour)

        expect(player.cards.length).to eq 0
        expect(neighbour.deck.length).to eq Neighbour::CARD_NUMBER_PER_NEIGHBOUR - 1
        expect(neighbour.discard.length).to eq 1
      end
    end
  end
end