RSpec.describe "Duel" do

  before do
    allow_any_instance_of(DeckFactory).to receive(:deck_by_neighbour).and_return DeckFactoryMock.duel_deck
    @game = Game.new(%w(jean francois michel))
    @attacker = @game.current_player
    @defender = @game.players[@game.next_player_index]
    @third_player = @game.players.detect { |p| p != @attacker && p != @defender }

    pawn_placement
  end

  it "should raise if opponent is not given" do
    expect { @game.draw_card(@attacker.lord_name, CardType::GANT) }.to raise_error Sbires::Error
  end

  it "should raise if opponent is the attacker" do
    expect { @game.draw_card(@attacker.lord_name, CardType::GANT, opponent: @attacker.lord_name) }.to raise_error Sbires::Error
  end

  it "should raise if opponent is unknown" do
    expect { @game.draw_card(@attacker.lord_name, CardType::GANT, opponent: "unknown") }.to raise_error Sbires::Error
  end

  context "duel launch" do
    before do
      @game.draw_card(@attacker.lord_name, CardType::GANT, opponent: @defender.lord_name)
    end

    it "should set the game in duel state" do
      expect(@game.state).to be_instance_of Duel
    end

    it "should only allow current/attacker to roll dice first" do
      expect { @game.roll_dice(@defender.lord_name) }.to raise_error Sbires::Error
    end

    it "should expose succeeded attack number" do
      mock_roll = [6, 6, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return mock_roll

      dice_result = @game.roll_dice(@attacker.lord_name)

      expect(dice_result).to eq mock_roll
    end

    it "should only allow defender to roll dice after attacker" do
      # attacker roll
      dice_result = [6, 6, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return dice_result
      @game.roll_dice(@attacker.lord_name)

      expect { @game.roll_dice(@attacker.lord_name) }.to raise_error Sbires::Error
    end

    it "should expose succeeded blocks number" do
      mock_attack_roll = [6, 6, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return mock_attack_roll
      @game.roll_dice(@attacker.lord_name)

      mock_defense_roll = [1, 2, 6]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return mock_defense_roll
      @game.roll_dice(@defender.lord_name)

      result = @game.end_turn

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

      @game.roll_dice(@defender.lord_name)

      result = @game.end_turn

      expect(result[:touches]).to eq 1
      expect(result[:blocks]).to eq 1
      expect(result[:winner]).to eq @defender
      expect(result[:loser]).to eq @attacker
    end

    it "should not make defender roll dice if attacker did not make any touches" do
      attacker_dice_roll = [1, 1, 1]
      allow_any_instance_of(DiceRoller).to receive(:roll).and_return attacker_dice_roll
      @game.roll_dice(@attacker.lord_name)

      result = @game.end_turn

      expect(result[:touches]).to eq 0
      expect(result[:blocks]).to eq 0
      expect(result[:winner]).to eq @defender
      expect(result[:loser]).to eq @attacker

      expect(@attacker.points).to eq 4
      expect(@defender.points).to eq 7
    end

    context "attacker wins" do
      before do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 6]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [1, 2, 3]
        @game.roll_dice(@defender.lord_name)

        @game.end_turn
      end

      it "should add 5 points to the attacker" do
        expect(@attacker.points).to eq 10
      end

      it "should remove as much attack not blocked as points to the defender" do
        expect(@defender.points).to eq 2
      end

      it "should have ended turn" do
        expect(@game.current_player).not_to eq @attacker
        expect(@game.current_player).to eq @defender
      end

      it "should have make a transition to play cards" do
        expect(@game.state).to be_instance_of PlayCards
      end
    end

    context "defender wins" do
      before do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 1, 1]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6]
        @game.roll_dice(@defender.lord_name)

        @game.end_turn
      end

      it "should remove 1 points to the attacker" do
        expect(@attacker.points).to eq 4
      end

      it "should add 2 points to the defender" do
        expect(@defender.points).to eq 7
      end

      it "should have ended turn" do
        expect(@game.current_player).not_to eq @attacker
        expect(@game.current_player).to eq @defender
      end

      it "should have make a transition to play cards" do
        expect(@game.state).to be_instance_of PlayCards
      end
    end

    context "duel with weapons" do
      it "should not allow any cards except equipment to be played after gant" do
        expect { @game.draw_card(@attacker.lord_name, CardType::DEMONSTRATION_MENESTREL) }.to raise_error Sbires::Error
      end

      it "should not allow other players than attacker or defender to draw an equipment card" do
        expect { @game.draw_card(@third_player.lord_name, CardType::DAGUE) }.to raise_error Sbires::Error
      end

      it "should allow attacker to draw an equipment card to attack stronger" do
        card_name = CardType::EPEE
        @game.draw_card(@attacker.lord_name, card_name)

        expect(@attacker.cards).not_to include an_object_having_attributes(name: card_name)
      end

      it "should not allow attacker to change equipment when he drew an equipment card" do
        @game.draw_card(@attacker.lord_name, CardType::EPEE)
        expect { @game.draw_card(@attacker.lord_name, CardType::DAGUE) }.to raise_error Sbires::Error
      end

      it "should allow defender to draw an equipment card to defend better" do
        card_name = CardType::COTTE_DE_MAILLES
        @game.draw_card(@defender.lord_name, card_name)

        expect(@defender.cards).not_to include an_object_having_attributes(name: card_name)
      end

      it "should not allow defender to change equipment when he drew an equipment card" do
        @game.draw_card(@defender.lord_name, CardType::COTTE_DE_MAILLES)
        expect { @game.draw_card(@defender.lord_name, CardType::DAGUE) }.to raise_error Sbires::Error
      end

      it "should not allow attacker to equip after rolling his dices" do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [2, 3, 4]
        @game.roll_dice(@attacker.lord_name)

        expect { @game.draw_card(@attacker.lord_name, CardType::EPEE) }.to raise_error Sbires::Error
      end

      it "should allow defender to equip after attacker rolled his dices" do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 6]
        @game.roll_dice(@attacker.lord_name)

        @game.draw_card(@defender.lord_name, CardType::COTTE_DE_MAILLES)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [4, 4, 4]
        @game.roll_dice(@defender.lord_name)

        result = @game.end_turn

        expect(result[:blocks]).to eq 3
        expect(result[:winner]).to eq @defender
      end

      it "should not allow defender to equip after rolling his dices" do
        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [2, 3, 6]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 6]
        @game.roll_dice(@defender.lord_name)

        expect { @game.draw_card(@defender.lord_name, CardType::COTTE_DE_MAILLES) }.to raise_error Sbires::Error
      end

      it "should make dice range success bigger according on equipment used for attack" do
        @game.draw_card(@attacker.lord_name, CardType::EPEE)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [2, 3, 4]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [6, 6, 4]
        @game.roll_dice(@defender.lord_name)

        result = @game.end_turn

        expect(result[:touches]).to eq 3
        expect(result[:winner]).to eq @attacker
      end

      it "should make dice range success bigger according on equipment used for defense" do
        @game.draw_card(@attacker.lord_name, CardType::EPEE)
        @game.draw_card(@defender.lord_name, CardType::COTTE_DE_MAILLES)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [2, 3, 2]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [3, 4, 4]
        @game.roll_dice(@defender.lord_name)

        result = @game.end_turn

        expect(result[:touches]).to eq 3
        expect(result[:blocks]).to eq 2
      end
    end

    context "end of a duel" do
      it "should not allow ending the turn if attack not done" do
        expect { @game.end_turn }.to raise_error Sbires::Error
      end

      it "should not allow ending the turn if attack succeed and defense not done" do
        @game.draw_card(@attacker.lord_name, CardType::EPEE)
        @game.draw_card(@defender.lord_name, CardType::COTTE_DE_MAILLES)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [2, 3, 2]
        @game.roll_dice(@attacker.lord_name)

        expect { @game.end_turn }.to raise_error Sbires::Error
      end

      it "should allow to end the turn if attack and defense done" do
        @game.draw_card(@attacker.lord_name, CardType::EPEE)
        @game.draw_card(@defender.lord_name, CardType::COTTE_DE_MAILLES)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [2, 3, 2]
        @game.roll_dice(@attacker.lord_name)

        allow_any_instance_of(DiceRoller).to receive(:roll).and_return [3, 4, 4]
        @game.roll_dice(@defender.lord_name)

        @game.end_turn

        expect(@game.current_player).to eq @defender
      end
    end
  end


  def pawn_placement
    @game.place_pawn(@attacker.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@defender.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@third_player.lord_name, NeighbourType::SALLE_D_ARMES)

    @game.place_pawn(@attacker.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@defender.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::SALLE_D_ARMES)
    @game.place_pawn(@third_player.lord_name, NeighbourType::CHATEAU)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::GRAND_PLACE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::CHATEAU)
    @game.place_pawn(@defender.lord_name, NeighbourType::EGLISE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::EGLISE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@defender.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::TAVERNE)

    @game.place_pawn(@attacker.lord_name, NeighbourType::GRAND_PLACE)
    @game.place_pawn(@defender.lord_name, NeighbourType::TAVERNE)
    @game.place_pawn(@third_player.lord_name, NeighbourType::TAVERNE)
  end
end