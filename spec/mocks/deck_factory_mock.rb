class DeckFactoryMock
  def self.unique_card_neighbour
    {
        NeighbourType::CHATEAU => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL) },
        NeighbourType::EGLISE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR) },
        NeighbourType::GRAND_PLACE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC) },
        NeighbourType::SALLE_D_ARMES => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::ARMURE_COMPLETE, min_touch: 4, min_block: 2) },
        NeighbourType::TAVERNE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::TAVERNE, CardType::BAGARRE_GENERALE) }
    }
  end

  def self.with_the_three_demonstrations
    {
        NeighbourType::CHATEAU => [
            Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
            Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
            Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),
            Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),
            Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR)],
        NeighbourType::EGLISE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR) },
        NeighbourType::GRAND_PLACE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC) },
        NeighbourType::SALLE_D_ARMES => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::ARMURE_COMPLETE, min_touch: 4, min_block: 2) },
        NeighbourType::TAVERNE => (0...Neighbour::CARD_NUMBER_PER_NEIGHBOUR).map { Card.new(NeighbourType::TAVERNE, CardType::BAGARRE_GENERALE) }
    }
  end
  
  def self.random_deck
    {
        NeighbourType::CHATEAU => DeckFactory.create_chateau_cards,
        NeighbourType::EGLISE => DeckFactory.create_eglise_cards,
        NeighbourType::GRAND_PLACE => DeckFactory.create_grand_place_cards,
        NeighbourType::SALLE_D_ARMES => DeckFactory.create_salle_d_armes_cards,
        NeighbourType::TAVERNE => DeckFactory.create_taverne_cards
    }
  end

  def self.duel_deck
    {
        NeighbourType::CHATEAU => DeckFactory.create_chateau_cards,
        NeighbourType::EGLISE => DeckFactory.create_eglise_cards,
        NeighbourType::GRAND_PLACE =>DeckFactory.create_grand_place_cards,
        NeighbourType::SALLE_D_ARMES => [
            Card.new(NeighbourType::SALLE_D_ARMES, CardType::EPEE, min_touch: 2, min_block: 4),
            Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES, min_touch: 5, min_block: 4),
            Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE, min_touch: 5, min_block: 4),
            *DeckFactory.create_salle_d_armes_cards
        ].take(Neighbour::CARD_NUMBER_PER_NEIGHBOUR),
        NeighbourType::TAVERNE => DeckFactory.create_taverne_cards
    }
  end

  def self.crieur_public_deck
    {
        NeighbourType::CHATEAU => DeckFactory.create_chateau_cards,
        NeighbourType::EGLISE => DeckFactory.create_eglise_cards,
        NeighbourType::GRAND_PLACE => [
            Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC),
            Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC),
            *DeckFactory.create_grand_place_cards
            ].take(Neighbour::CARD_NUMBER_PER_NEIGHBOUR),
        NeighbourType::SALLE_D_ARMES => DeckFactory.create_salle_d_armes_cards,
        NeighbourType::TAVERNE => DeckFactory.create_taverne_cards
    }
  end

  def self.card_on_top(neighbour_type, card_type)
    deck = random_deck

    deck[neighbour_type] = deck[neighbour_type].unshift(Card.new(neighbour_type, card_type)).take(26)
    
    deck
  end
end