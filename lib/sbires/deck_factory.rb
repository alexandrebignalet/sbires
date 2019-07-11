class DeckFactory
  def initialize
    @deck_by_neighbour = deck_by_neighbour
  end

  def create_deck_for(neighbour_name)
    @deck_by_neighbour[neighbour_name]
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
    [
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_MENESTREL),

        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_FABULISTE),

        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),
        Card.new(NeighbourType::CHATEAU, CardType::DEMONSTRATION_AMUSEUR),

        Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS),
        Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS),
        Card.new(NeighbourType::CHATEAU, CardType::MONTREUR_DOURS),

        Card.new(NeighbourType::CHATEAU, CardType::GARDE),
        Card.new(NeighbourType::CHATEAU, CardType::GARDE),

        Card.new(NeighbourType::CHATEAU, CardType::INTRIGUE),

        Card.new(NeighbourType::CHATEAU, CardType::COURTISANE),

        Card.new(NeighbourType::CHATEAU, CardType::ELOQUENCE)
    ]
  end

  def create_eglise_cards
    [
        Card.new(NeighbourType::EGLISE, CardType::PRIERE),
        Card.new(NeighbourType::EGLISE, CardType::PRIERE),
        Card.new(NeighbourType::EGLISE, CardType::PRIERE),
        Card.new(NeighbourType::EGLISE, CardType::PRIERE),
        Card.new(NeighbourType::EGLISE, CardType::PRIERE),

        Card.new(NeighbourType::EGLISE, CardType::EAU_BENITE),
        Card.new(NeighbourType::EGLISE, CardType::EAU_BENITE),
        Card.new(NeighbourType::EGLISE, CardType::EAU_BENITE),
        Card.new(NeighbourType::EGLISE, CardType::EAU_BENITE),
        Card.new(NeighbourType::EGLISE, CardType::EAU_BENITE),

        Card.new(NeighbourType::EGLISE, CardType::ENFANTS_DE_CHOEUR),
        Card.new(NeighbourType::EGLISE, CardType::ENFANTS_DE_CHOEUR),
        Card.new(NeighbourType::EGLISE, CardType::ENFANTS_DE_CHOEUR),
        Card.new(NeighbourType::EGLISE, CardType::ENFANTS_DE_CHOEUR),
        Card.new(NeighbourType::EGLISE, CardType::ENFANTS_DE_CHOEUR),

        Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR),
        Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR),
        Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR),
        Card.new(NeighbourType::EGLISE, CardType::FOSSOYEUR),

        Card.new(NeighbourType::EGLISE, CardType::PENITENT),
        Card.new(NeighbourType::EGLISE, CardType::PENITENT),
        Card.new(NeighbourType::EGLISE, CardType::PENITENT),
        Card.new(NeighbourType::EGLISE, CardType::PENITENT),

        Card.new(NeighbourType::EGLISE, CardType::INQUISITION),

        Card.new(NeighbourType::EGLISE, CardType::BIGOTES),

        Card.new(NeighbourType::EGLISE, CardType::PROVIDENCE)
    ]
  end

  def create_grand_place_cards
    [
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),
        Card.new(NeighbourType::GRAND_PLACE, CardType::GANT),

        Card.new(NeighbourType::GRAND_PLACE, CardType::CONCIERGE),
        Card.new(NeighbourType::GRAND_PLACE, CardType::CONCIERGE),
        Card.new(NeighbourType::GRAND_PLACE, CardType::CONCIERGE),

        Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC),
        Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC),
        Card.new(NeighbourType::GRAND_PLACE, CardType::CRIEUR_PUBLIC),

        Card.new(NeighbourType::GRAND_PLACE, CardType::FOUINEUR),
        Card.new(NeighbourType::GRAND_PLACE, CardType::FOUINEUR),

        Card.new(NeighbourType::GRAND_PLACE, CardType::APOTHICAIRE),
        Card.new(NeighbourType::GRAND_PLACE, CardType::APOTHICAIRE),

        Card.new(NeighbourType::GRAND_PLACE, CardType::PILORI),
        Card.new(NeighbourType::GRAND_PLACE, CardType::PILORI),

        Card.new(NeighbourType::GRAND_PLACE, CardType::VIEILLE_DAME),

        Card.new(NeighbourType::GRAND_PLACE, CardType::VAILLANCE)
    ]
  end

  def create_salle_d_armes_cards
    [
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::DAGUE),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::GOURDIN),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::GOURDIN),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::GOURDIN),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::GOURDIN),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::HACHE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::HACHE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::HACHE),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::HACHE),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::EPEE),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::COTTE_DE_MAILLES),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::ECU_DE_FER),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::ECU_DE_FER),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::ECU_DE_FER),
        Card.new(NeighbourType::SALLE_D_ARMES, CardType::ECU_DE_FER),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::ARMURE_COMPLETE),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::JOUVENCELLE),

        Card.new(NeighbourType::SALLE_D_ARMES, CardType::CONFIANCE)
    ]
  end

  def create_taverne_cards
    [
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),
        Card.new(NeighbourType::TAVERNE, CardType::RAGOTS_ET_FORFANTERIES),

        Card.new(NeighbourType::TAVERNE, CardType::PASSE_PASSE),
        Card.new(NeighbourType::TAVERNE, CardType::PASSE_PASSE),
        Card.new(NeighbourType::TAVERNE, CardType::PASSE_PASSE),
        Card.new(NeighbourType::TAVERNE, CardType::PASSE_PASSE),

        Card.new(NeighbourType::TAVERNE, CardType::IVROGNE),
        Card.new(NeighbourType::TAVERNE, CardType::IVROGNE),
        Card.new(NeighbourType::TAVERNE, CardType::IVROGNE),
        Card.new(NeighbourType::TAVERNE, CardType::IVROGNE),

        Card.new(NeighbourType::TAVERNE, CardType::RACINE_DE_BELLADONE),
        Card.new(NeighbourType::TAVERNE, CardType::RACINE_DE_BELLADONE),
        Card.new(NeighbourType::TAVERNE, CardType::RACINE_DE_BELLADONE),
        Card.new(NeighbourType::TAVERNE, CardType::RACINE_DE_BELLADONE),

        Card.new(NeighbourType::TAVERNE, CardType::FELON),
        Card.new(NeighbourType::TAVERNE, CardType::FELON),
        Card.new(NeighbourType::TAVERNE, CardType::FELON),

        Card.new(NeighbourType::TAVERNE, CardType::BAGARRE_GENERALE),

        Card.new(NeighbourType::TAVERNE, CardType::PATRONNE),

        Card.new(NeighbourType::TAVERNE, CardType::INFLUENCE)
    ]
  end
end