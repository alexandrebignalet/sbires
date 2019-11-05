def start_two_players_game(deck, pawns_repartition)
  allow_any_instance_of(DeckFactory).to receive(:factories).and_return(deck)
  players = Game.prepare_players(%w(jean francois))
  @game = Game.new(players)
  @first_player = @game.current_player
  @second_player = @game.players.detect { |p| p != @first_player }

  pawn_placement(pawns_repartition)
end

def pawn_placement(pawns_repartition)
  index = 2
  
  pawns_repartition.each do |neighbour_type|
    player = index % 2 == 0 ? @first_player : @second_player

    @game.place_pawn(player.lord_name, neighbour_type)
    index += 1
  end
end