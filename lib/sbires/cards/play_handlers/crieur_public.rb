module PlayHandlers
  class CrieurPublic
    def run(play)
      raise Sbires::Error, "Not your turn" unless play.submitter == play.game.current_player

      current_player = play.game.current_player

      grand_place = play.game.find_neighbour play.card.neighbour_name
      current_player.discard_in(play.card, grand_place)

      play.game.neighbours_dominants.each do |neighbour_dominant|
        dominant, neighbour = neighbour_dominant
        next if dominant != current_player.lord_name

        current_player.pick_top_card_of_deck neighbour
      end

      play.game.end_turn
    end

    def listen_to(card)
      [CardType::CRIEUR_PUBLIC].include? card.name
    end
  end
end