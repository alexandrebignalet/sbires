class DeckFactoryMock
  def self.unique_card_neighbour
    {
        NeighbourType::CHATEAU => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL) },
        NeighbourType::EGLISE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR) },
        NeighbourType::GRAND_PLACE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC) },
        NeighbourType::SALLE_D_ARMES => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::ARMURE_COMPLETE) },
        NeighbourType::TAVERNE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::TAVERNE, CardType::BAGARRE_GENERALE) }
    }
  end
end