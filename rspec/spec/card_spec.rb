# frozen_string_literal: true

require 'set'
require 'spec_helper'
require 'card'

RSpec.describe Card, :unit do
  def card(params = {})
    defaults = {
      suit: :hearts,
      rank: 7
    }

    Card.build(*defaults.merge(params).values_at(:suit, :rank))
  end

  context 'attributes' do
    it 'has a suit' do
      expect(card(suit: :spades).suit).to eq(:spades)
    end

    it 'has a rank' do
      expect(card(rank: 4).rank).to eq(4)
    end
  end

  context 'equality' do
    subject { card(suit: :spades, rank: 4) }

    describe 'comparing to itself' do
      let(:other) { card(suit: :spades, rank: 4) }

      it 'is equal' do
        expect(subject).to eq(other)
      end

      it 'is hash equal' do
        expect(Set.new([subject, other]).size).to eq(1)
      end
    end

    shared_examples_for 'an unequal card' do
      it 'is not equal' do
        expect(subject).not_to eq(other)
      end

      it 'is not hash equal' do
        expect(Set.new([subject, other]).size).to eq(2)
      end
    end

    describe 'comparing to a card of different suit' do
      let(:other) { card(suit: :hearts, rank: 4) }
      it_behaves_like 'an unequal card'
    end

    describe 'comparing to a card of different rank' do
      let(:other) { card(suit: :spades, rank: 10) }
      it_behaves_like 'an unequal card'
    end
  end

  describe 'a jack' do
    it 'ranks higher than a 10' do
      lower = card(rank: 10)
      higher = card(rank: :jack)

      raise unless higher.rank > lower.rank
    end
  end

  describe 'a queen' do
    it 'ranks higher than a jack' do
      lower = card(rank: :jack)
      higher = card(rank: :queen)

      raise unless higher.rank > lower.rank
    end
  end

  describe 'a king' do
    it 'ranks higher than a queen' do
      lower = card(rank: :queen)
      higher = card(rank: :king)

      expect(higher.rank).to be > lower.rank
    end
  end

  describe 'an ace' do
    it 'ranks higher than a king' do
      lower = card(rank: :king)
      higher = card(rank: :ace)

      expect(higher.rank).to be > lower.rank
    end
  end

  describe '.from_string' do
    def self.it_parses(string, as:)
      it "parses #{as}" do
        expect(Card.from_string(string)).to eq(as)
      end
    end

    it_parses '7H', as: Card.build(:hearts, 7)
    it_parses '10S', as: Card.build(:spades, 10)
    it_parses 'JC', as: Card.build(:clubs, :jack)
    it_parses 'JC', as: Card.build(:clubs, :jack)
    it_parses 'JC', as: Card.build(:clubs, :jack)
  end
end
