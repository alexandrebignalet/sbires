RSpec.describe "Duel" do

  before do
    allow_any_instance_of(DeckFactory).to receive(:deck_by_neighbour).and_return DeckFactoryMock.duel_deck
    @game = Game.new(%w(jean francois))
  end

  it "should start with a Gant played" do

  end
end