class DeckFactory
  def create_deck_for(neighbour_name)
    deck_by_neighbour[neighbour_name]
  end

  private

  def deck_by_neighbour
    {
        NeighbourType::CHATEAU => create_chateau_cards,
        NeighbourType::EGLISE => create_eglise_cards,
        NeighbourType::GRAND_PLACE => create_grand_place_cards,
        NeighbourType::SALLE_D_ARMES => create_salle_d_armes_cards,
        NeighbourType::TAVERNE => create_taverne_cards
    }
  end

  def create_chateau_cards
    (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL) }
  end

  def create_eglise_cards
    (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR) }
  end

  def create_grand_place_cards
    (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC) }
  end

  def create_salle_d_armes_cards
    (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::ARMURE_COMPLETE) }
  end

  def create_taverne_cards
    (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::TAVERNE, CardType::BAGARRE_GENERALE) }
  end
end