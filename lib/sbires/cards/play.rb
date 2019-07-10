class Play
  attr_reader :submitter_lord_name, :card_name
  
  def initialize(submitter_lord_name, card_name)
    @submitter_lord_name = submitter_lord_name
    @card_name = card_name
  end
end