class Play
  attr_reader :game, :submitter, :card, :params
  
  def initialize(game, submitter, card, params)
    @game = game
    @submitter = submitter
    @card = card
    @params = params
  end
end