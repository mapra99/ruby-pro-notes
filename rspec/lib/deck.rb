require 'card'

class Deck
  RANKS = (7..10).to_a + %i[jack queen king ace]

  SUITS = %i[hearts clubs diamonds spades].freeze

  def self.all
    RANKS.product(SUITS).map do |rank, suit|
      Card.build(suit, rank)
    end
  end
end
