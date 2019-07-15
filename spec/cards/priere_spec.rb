RSpec.describe "Priere cards played" do

  before do
    allow_any_instance_of(DeckFactory).to receive(:deck_by_neighbour).and_return DeckFactoryMock.duel_deck
    @game = Game.new(%w(jean mich hugs))

    @first_player = @game.current_player
    @second_player = @game.players[@game.next_player_index]
    @third_player = @game.players.detect { |p| p != @first_player && p != @second_player }

    pawn_placement
  end

  it "should not be played outside a duel" do
    expect { @game.draw_card(@first_player.lord_name, CardType::PRIERE) }.to raise_error Sbires::Error
  end

  context "during a duel" do
    before do
      @game.draw_card(@first_player.lord_name, CardType::GANT, opponent: @second_player.lord_name)
    end

    it "should not be played by another player not in duel" do
      expect { @game.draw_card(@third_player.lord_name, CardType::PRIERE) }.to raise_error Sbires::Error
    end

    it "should not be played before any rolled dices" do
      expect { @game.draw_card(@first_player.lord_name, CardType::PRIERE) }.to raise_error Sbires::Error
    end

    # it "should only be played by current player" do
    #   expect { @game.draw_card(@second_player.lord_name, CardType::PRIERE) }.to raise_error Sbires::Error, "Cannot be used for another player"
    # end

    it "should target a dice to reroll" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 1]
      @game.roll_dice(@first_player.lord_name)

      expect { @game.draw_card(@first_player.lord_name, CardType::PRIERE) }.to raise_error Sbires::Error
    end

    it "should raise if targeted dice to reroll does not exist" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 1]
      @game.roll_dice(@first_player.lord_name)

      expect { @game.draw_card(@first_player.lord_name, CardType::PRIERE, reroll_dice: 5) }.to raise_error Sbires::Error
    end

    it "should allow attacker to reroll a dice" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 1, 1]

      @game.roll_dice(@first_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).with(1).and_return [6]
      @game.draw_card(@first_player.lord_name, CardType::PRIERE, reroll_dice: 1)

      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [1, 6, 1]
      @game.roll_dice(@second_player.lord_name)

      result = @game.end_turn

      expect(result[:winner]).to eq @first_player
    end

    it "should allow defender to reroll a dice" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 1]
      @game.roll_dice(@first_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [1, 6, 1]
      @game.roll_dice(@second_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).with(1).and_return [6]
      @game.draw_card(@second_player.lord_name, CardType::PRIERE, reroll_dice: 1)

      result = @game.end_turn
      expect(result[:winner]).to eq @second_player
    end

    # what if priere for defender after attacker roll ?
    #     # defender equipment before attacker roll

    it "should not allow attacker to draw a Priere after defender roll" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 1]
      @game.roll_dice(@first_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [1, 6, 1]
      @game.roll_dice(@second_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).with(1).and_return [6]
      expect { @game.draw_card(@first_player.lord_name, CardType::PRIERE, reroll_dice: 1) }.to raise_error Sbires::Error
    end

    it "should not allow defender to draw a Priere after attacker roll" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 1]
      @game.roll_dice(@first_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).with(1).and_return [6]
      expect { @game.draw_card(@second_player.lord_name, CardType::PRIERE, reroll_dice: 1) }.to raise_error Sbires::Error
    end
  end

  def pawn_placement
    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@third_player.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::EGLISE)


    @game.place_pawn(@first_player.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@third_player.lord_name, NeighbourType::EGLISE)


    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@third_player.lord_name, NeighbourType::CHATEAU)


    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::GRAND_PLACE)


    @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::GRAND_PLACE)


    @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::TAVERNE)


    @game.place_pawn(@first_player.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::TAVERNE)

  end
end