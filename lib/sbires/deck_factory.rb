class DeckFactory

  def create_deck_for(neighbour_name)
    factories[neighbour_name]
  end

  private

  def factories
    {
        NeighbourType::CHATEAU => DeckFactory.create_chateau_cards.shuffle,
        NeighbourType::EGLISE => DeckFactory.create_eglise_cards.shuffle,
        NeighbourType::GRAND_PLACE => DeckFactory.create_grand_place_cards.shuffle,
        NeighbourType::SALLE_D_ARMES => DeckFactory.create_salle_d_armes_cards.shuffle,
        NeighbourType::TAVERNE => DeckFactory.create_taverne_cards.shuffle
    }
  end

  def self.create_chateau_cards
    [
        *(0...6).map { Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL) },

        *(0...6).map { Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE) },

        *(0...6).map { Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR) },

        *(0...3).map { Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS) },

        *(0...2).map { Card.new(NeighbourType::CHATEAU, CardType::GARDE) },

        Card.new(NeighbourType::CHATEAU, CardType::INTRIGUE),

        Card.new(NeighbourType::CHATEAU, CardType::COURTISANE),

        Card.new(NeighbourType::CHATEAU, CardType::ELOQUENCE)
    ]
  end

  def self.create_eglise_cards
    [
        *(0...5).map { Card.new(NeighbourType::EGLISE, CardType::PRIERE, buff: true) },

        *(0...5).map { Card.new(NeighbourType::EGLISE, CardType::EAU_BENITE) },

        *(0...5).map { Card.new(NeighbourType::EGLISE, CardType::ENFANTS_DE_CHOEUR) },

        *(0...4).map { Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR) },

        *(0...4).map { Card.new(NeighbourType::EGLISE, CardType::PENITENT) },

        Card.new(NeighbourType::EGLISE, CardType::INQUISITION),

        Card.new(NeighbourType::EGLISE, CardType::BIGOTES),

        Card.new(NeighbourType::EGLISE, CardType::PROVIDENCE)
    ]
  end

  def self.create_grand_place_cards
    [
        *(0...12).map { Card.new(NeighbourType::GRAND_PLACE, CardType::GANT) },

        *(0...3).map { Card.new(NeighbourType::GRAND_PLACE, CardType::CONCIERGE) },

        *(0...3).map { Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC) },

        *(0...2).map { Card.new(NeighbourType::GRAND_PLACE, CardType::FOUINEUR) },

        *(0...2).map { Card.new(NeighbourType::GRAND_PLACE, CardType::APOTHICAIRE) },

        *(0...2).map { Card.new(NeighbourType::GRAND_PLACE, CardType::PILORI) },

        Card.new(NeighbourType::GRAND_PLACE, CardType::VIEILLE_DAME),

        Card.new(NeighbourType::GRAND_PLACE, CardType::VAILLANCE)
    ]
  end

  def self.create_salle_d_armes_cards
    [
        *(0...5).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE, min_touch: 5, min_block: 5) },

        *(0...4).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::GOURDIN, min_touch: 4, min_block: 5) },

        *(0...4).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::HACHE, min_touch: 3, min_block: 5) },

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::EPEE, min_touch: 2, min_block: 4),

        *(0...5).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES, min_touch: 5, min_block: 4) },

        *(0...4).map { Card.new(NeighbourType::SALLE_D_ARMES, CardType::ECU_DE_FER, min_touch: 5, min_block: 3) },

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::ARMURE_COMPLETE, min_touch: 4, min_block: 2),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::JOUVENCELLE),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::CONFIANCE)
    ]
  end

  def self.create_taverne_cards
    [
        *(0...8).map { Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES) },

        *(0...4).map { Card.new(NeighbourType::TAVERNE, CardType::PASSE_PASSE) },

        *(0...4).map { Card.new(NeighbourType::TAVERNE, CardType::IVROGNE) },

        *(0...4).map { Card.new(NeighbourType::TAVERNE, CardType::RACINE_DE_BELLADONE) },

        *(0...3).map { Card.new(NeighbourType::TAVERNE, CardType::FELON) },

        Card.new(NeighbourType::TAVERNE, CardType::BAGARRE_GENERALE),

        Card.new(NeighbourType::TAVERNE, CardType::PATRONNE),

        Card.new(NeighbourType::TAVERNE, CardType::INFLUENCE)
    ]
  end
end