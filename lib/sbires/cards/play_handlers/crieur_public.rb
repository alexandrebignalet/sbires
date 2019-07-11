module PlayHandlers
  class CrieurPublic
    def run(play)
      current_player = play.game.current_player
      raise Sbires::Error, "Not your turn" unless play.submitter == current_player

      grand_place = play.game.find_neighbour play.card.neighbour_name
      current_player.discard_in(play.card, grand_place)

      play.game.neighbours_dominants.each do |neighbour_dominant|
        dominant = neighbour_dominant.first
        next if dominant.nil? || dominant != current_player.lord_name

        neighbour = neighbour_dominant.last
        current_player.pick_top_card_of_deck neighbour
      end

      play.game.end_turn
    end

    def listen_to(card)
      [CardType::CRIEUR_PUBLIC].include? card.name
    end
  end
end