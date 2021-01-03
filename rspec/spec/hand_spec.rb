require 'high_card'
require_relative 'matchers/high_card_matchers'

describe 'hand rankings', :aggregate_failures do
  include HighCardMatchers

  example 'hand with highest card wins' do
    expect(%w[10H]).to beat(%w[9H])
    expect(%w[9H]).not_to beat(%w[10H])
    expect(%w[6H 10H]).to beat(%w[9H])
    expect(%w[8H 9H]).not_to beat(%w[6H 10H])
  end
end
