require 'deck'
require_relative 'matchers/array_matchers'

describe Deck, :unit do
  include ArrayMatchers

  describe '.all' do
    it 'contains 32 cards' do
      expect(Deck.all.length).to eq(32)
    end

    it 'has a seven as its lowest card' do
      expect(Deck.all).to all(have_attributes(rank: be >= 7))
    end

    it 'has contiguous ranks by suit' do
      expect(Deck.all.group_by(&:suit).values).to all(be_contiguous_by(&:rank))
    end
  end
end
