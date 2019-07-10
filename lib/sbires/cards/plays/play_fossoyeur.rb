class PlayFossoyeur < Play
  attr_reader :neighbour_discard, :chosen_card_name

  def initialize(submitter_lord_name, neighbour_discard, chosen_card_name)
    super(submitter_lord_name, CardType::FOSSOYEUR)
    @neighbour_discard = neighbour_discard
    @chosen_card_name = chosen_card_name
  end
end