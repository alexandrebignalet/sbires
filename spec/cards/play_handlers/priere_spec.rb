RSpec.describe "Priere cards played" do

  before do
    allow_any_instance_of(DeckFactory).to receive(:factories).and_return DeckFactoryMock.duel_deck
    remaining_lord_names = Game::LORD_NAMES.dup
    first_player = Player.new('mich', remaining_lord_names.shift)
    second_player = Player.new('jean', remaining_lord_names.shift, spare: [1, 2, 3, 4, 5, 6, 7, 8])
    third_player = Player.new('hugs', remaining_lord_names.shift)
    @game = Game.new([first_player, second_player, third_player], current_player_index: 0)
    @first_player = @game.current_player
    @second_player = @game.players[@game.next_player_index]
    @third_player = @game.players.detect { |p| p != @first_player && p != @second_player }

    pawn_placement
  end

  context "outside a duel" do
    before do
      @game.draw_card(@first_player.lord_name, CardType::PRIERE)
    end

    it "should add the card in current player spare" do
      expect(@first_player.spare).to include( have_attributes(name: CardType::PRIERE) )
    end

    it "should raise if player spare is full" do
      expect { @game.draw_card(@second_player.lord_name, CardType::PRIERE) }.to raise_error Sbires::Error
    end

    it 'should end the current player turn' do
      expect(@game.current_player.lord_name).to_not eq(@first_player.lord_name)
    end
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

      expect(result[:winner].is_player?(@first_player)).to be true
    end

    it "should allow defender to reroll a dice" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 1]
      @game.roll_dice(@first_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [1, 6, 1]
      @game.roll_dice(@second_player.lord_name)

      allow_any_instance_of(DiceRoller).to receive(:roll).with(1).and_return [6]
      @game.draw_card(@second_player.lord_name, CardType::PRIERE, reroll_dice: 1)

      result = @game.end_turn
      expect(result[:winner].is_player?(@second_player)).to be true
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