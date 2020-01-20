def start_two_players_game(deck, pawns_repartition = nil)
  allow_any_instance_of(DeckFactory).to receive(:factories).and_return(deck)
  players = Game.prepare_players(%w(jean francois))
  @game = Game.new(players)
  @first_player = @game.current_player
  @second_player = @game.players.detect { |p| p != @first_player }

  pawns_repartition.nil? ? default_pawns_placement : pawn_placement(pawns_repartition)
end

def default_pawns_placement
  @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
  @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)

  @game.place_pawn(@first_player.lord_name, NeighbourType::SALLE_D_ARMES)
  @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

  @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
  @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

  @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
  @game.place_pawn(@second_player.lord_name, NeighbourType::SALLE_D_ARMES)

  @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
  @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)

  @game.place_pawn(@first_player.lord_name, NeighbourType::CHATEAU)
  @game.place_pawn(@second_player.lord_name, NeighbourType::EGLISE)

  @game.place_pawn(@first_player.lord_name, NeighbourType::TAVERNE)
  @game.place_pawn(@second_player.lord_name, NeighbourType::GRAND_PLACE)

  @game.place_pawn(@first_player.lord_name, NeighbourType::GRAND_PLACE)
  @game.place_pawn(@second_player.lord_name, NeighbourType::TAVERNE)
end

def pawn_placement(pawns_repartition)
  index = 2
  
  pawns_repartition.each do |neighbour_type|
    player = index % 2 == 0 ? @first_player : @second_player

    @game.place_pawn(player.lord_name, neighbour_type)
    index += 1
  end
end