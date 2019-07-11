module PlayHandlers
  class Demonstration
    def run(play)
      current_player = play.game.current_player
      raise Sbires::Error, "No more than 3 demonstrations in spare allowed" if three_demonstration_in_spare? current_player

      current_player.spare_card(play.card)
    end

    def listen_to(card)
      Demonstration.demonstration_cards.include? card.name
    end

    private

    def self.demonstration_cards
      [CardType::DEMONSTRATION_MENESTREL,
       CardType::DEMONSTRATION_AMUSEUR,
       CardType::DEMONSTRATION_FABULISTE]
    end

    def three_demonstration_in_spare?(current_player)
      demonstrations_in_spare = current_player.spare.select { |c| Demonstration.demonstration_cards.include? c.name }
      demonstrations_in_spare.length == 3
    end
  end
end