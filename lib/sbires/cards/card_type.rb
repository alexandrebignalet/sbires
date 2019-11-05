class CardType
  DEMONSTRATION_MENESTREL = "Démonstration Ménestrel"
  DEMONSTRATION_FABULISTE = "Démonstration Fabuliste"
  DEMONSTRATION_AMUSEUR = "Démonstration Amuseur"
  MONTREUR_DOURS = "Montreur d'ours"
  GARDE = "Garde"
  INTRIGUE = "Intrigue"
  COURTISANE = "Courtisane"
  ELOQUENCE = "Eloquence"

  PRIERE = "Prière"
  EAU_BENITE = "Eau bénite"
  ENFANTS_DE_CHOEUR = "Enfants de choeur"
  FOSSOYEUR = "Fossoyeur"
  PENITENT = "Pénitent"
  INQUISITION = "Inquisition"
  BIGOTES = "Bigottes"
  PROVIDENCE = "Providence"

  GANT = "Gant"
  CONCIERGE = "Concierge"
  CRIEUR_PUBLIC = "Crieur public"
  FOUINEUR = "Fouineur"
  APOTHICAIRE = "Apothicaire"
  PILORI = "Pilori"
  VIEILLE_DAME = "Vieille dame"
  VAILLANCE = "Vaillance"

  DAGUE = "Dague"
  GOURDIN = "Gourdin"
  HACHE = "Hache"
  EPEE = "Epée"
  COTTE_DE_MAILLES = "Cotte de mailles"
  ECU_DE_FER = "Ecu de fer"
  ARMURE_COMPLETE = "Armure complète"
  JOUVENCELLE = "Jouvencelle"
  CONFIANCE = "Confiance"

  RAGOTS_ET_FORFANTERIES = "Ragots et forfanteries"
  PASSE_PASSE = "Passe-passe"
  IVROGNE = "Ivrogne"
  RACINE_DE_BELLADONE = "Racines de belladone"
  FELON = "Félon"
  BAGARRE_GENERALE = "Bagarre générale"
  PATRONNE = "Patronne"
  INFLUENCE = "Influence"

  def self.demonstration_cards
    [CardType::DEMONSTRATION_MENESTREL,
     CardType::DEMONSTRATION_AMUSEUR,
     CardType::DEMONSTRATION_FABULISTE]
  end
end