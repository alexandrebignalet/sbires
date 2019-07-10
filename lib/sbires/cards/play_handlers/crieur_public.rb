module PlayHandlers
  class CrieurPublic
    def run(game, play)
      current_player = game.current_player
      raise Sbires::Error, "Not your turn" if play.submitter_lord_name != current_player.lord_name

      grand_place = game.find_neighbour NeighbourType::GRAND_PLACE
      current_player.discard_in(play.card_name, grand_place)

      game.neighbours_dominants.each do |neighbour_dominant|
        dominant = neighbour_dominant.first
        next if dominant.nil? || dominant != current_player.lord_name

        neighbour = neighbour_dominant.last
        current_player.pick_top_card_of_deck neighbour
      end

      game.end_turn
    end

    def listen_to(card_name)
      [CardType::CRIEUR_PUBLIC].include? card_name
    end
  end
end