RSpec.describe "Duel" do

  before do
    allow_any_instance_of(DeckFactory).to receive(:deck_by_neighbour).and_return DeckFactoryMock.duel_deck
    @game = Game.new(%w(jean francois))
    @attacker = @game.current_player
    @defender = @game.players.detect { |p| p != @attacker }

    pawn_placement
  end

  it "should raise if target is not given" do
    expect { @game.draw_card(@attacker.lord_name, CardType::GANT) }.to raise_error Sbires::Error
  end

  it "should raise if target is unknown" do
    expect { @game.draw_card(@attacker.lord_name, CardType::GANT, target: "unknown") }.to raise_error Sbires::Error
  end

  context "duel launch" do
    before do
      @game.draw_card(@attacker.lord_name, CardType::GANT, target: @defender.lord_name)
    end

    it "should set the game in duel state" do
      expect(@game.state).to be_instance_of Duel
    end

    it "should only allow current/attacker to roll dice first" do
      expect { @game.roll_dice(@defender.lord_name) }.to raise_error Sbires::Error
    end

    it "should expose succeeded attack number" do
      dice_result = [6, 6, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return dice_result

      result = @game.roll_dice(@attacker.lord_name)

      expect(result[:dice_result]).to eq dice_result
      expect(result[:touches]).to eq 3
      expect(result[:blocks]).to eq nil
      expect(result[:winner]).to eq nil
      expect(result[:loser]).to eq nil
    end

    it "should only allow defender to roll dice after attacker" do
      # attacker roll
      dice_result = [6, 6, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return dice_result
      @game.roll_dice(@attacker.lord_name)

      expect { @game.roll_dice(@attacker.lord_name) }.to raise_error Sbires::Error
    end

    it "should expose succeeded blocks number" do
      dice_result = [6, 6, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return dice_result
      @game.roll_dice(@attacker.lord_name)

      dice_result = [1, 2, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return dice_result

      result = @game.roll_dice(@defender.lord_name)

      expect(result[:dice_result]).to eq dice_result
      expect(result[:touches]).to eq 3
      expect(result[:blocks]).to eq 1
      expect(result[:winner]).to eq @attacker
      expect(result[:loser]).to eq @defender
    end

    it "should give defender a dice number to roll equal to the number of attack touches" do
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 1, 1]
      @game.roll_dice(@attacker.lord_name)

      defender_dice_result = [6]
      allow_any_instance_of(DiceRoller).to receive(:roll).with(1).and_return defender_dice_result

      result = @game.roll_dice(@defender.lord_name)

      expect(result[:dice_result]).to eq defender_dice_result
      expect(result[:touches]).to eq 1
      expect(result[:blocks]).to eq 1
      expect(result[:winner]).to eq @defender
      expect(result[:loser]).to eq @attacker
    end

    it "should not make defender roll dice if attacker did not make any touches" do
      attacker_dice_roll = [1, 1, 1]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return attacker_dice_roll
      result = @game.roll_dice(@attacker.lord_name)

      expect(result[:dice_result]).to eq attacker_dice_roll
      expect(result[:touches]).to eq 0
      expect(result[:blocks]).to eq nil
      expect(result[:winner]).to eq @defender
      expect(result[:loser]).to eq @attacker
      expect(@attacker.points).to eq 4
      expect(@defender.points).to eq 7
    end

    # raise if rolls after end of turn

    context "attacker wins" do
      before do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 6]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [1, 2, 3]
        @game.roll_dice(@defender.lord_name)
      end

      it "should add 5 points to the attacker" do
        expect(@attacker.points).to eq 10
      end

      it "should remove as much attack not blocked as points to the defender" do
        expect(@defender.points).to eq 2
      end

      it "should have ended turn" do
        expect(@game.current_player).not_to eq @attacker
      end
    end

    context "defender wins" do
      before do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 1, 1]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6]
        @game.roll_dice(@defender.lord_name)
      end

      it "should remove 1 points to the attacker" do
        expect(@attacker.points).to eq 4
      end

      it "should add 2 points to the defender" do
        expect(@defender.points).to eq 7
      end

      it "should have ended turn" do
        expect(@game.current_player).not_to eq @attacker
      end
    end
  end


  def pawn_placement
    @game.place_pawn(@attacker.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@defender.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@defender.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@defender.lord_name, NeighbourType::TAVERNE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@defender.lord_name, NeighbourType::TAVERNE)
  end
end