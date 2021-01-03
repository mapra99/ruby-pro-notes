# frozen_string_literal: true

class Card
  attr_reader :suit, :rank

  private_class_method :new

  def initialize(suit:, rank:)
    @suit = suit
    @rank = case rank
            when :jack then 11
            when :queen then 12
            when :king then 13
            when :ace then 14
            else rank
            end
  end

  def self.build(suit, rank)
    new(suit: suit, rank: rank)
  end

  def self.from_string(value)
    # Get final character in string
    short_suit = value[-1]

    # Map it to a suit
    suit = {
      'H' => :hearts,
      'D' => :diamonds,
      'S' => :spades,
      'C' => :clubs
    }.fetch(short_suit)

    # Map remainder to a face card, or fallback to numeric
    rank = {
      'A' => :ace,
      'K' => :king,
      'Q' => :queen,
      'J' => :jack
    }.fetch(value[0]) { value[0..-2].to_i }

    Card.build(suit, rank)
  end

  def ==(other)
    suit == other.suit && rank == other.rank
  end

  def inspect
    to_s
  end

  def to_s
    id = if rank > 10
           {
             11 => 'J',
             12 => 'Q',
             13 => 'K',
             14 => 'A'
           }.fetch(rank)
         else
           rank.to_s
         end

    s = {
      hearts: '♡ ',
      spades: '♤ ',
      diamonds: '♢ ',
      clubs: '♧ '
    }

    "#{id.upcase}#{s.fetch(suit)}"
  end

  private

  def hash
    [suit, rank].hash
  end

  def eql?(other)
    self == other
  end
end
