module HighCardMatchers
  extend RSpec::Matchers::DSL

  matcher(:beat) do |losing|
    match do |winning|
      HighCard.beats?(hand(winning), hand(losing))
    end

    failure_message do |winning|
      "expected <#{hand(winning).join(' ')}> to beat <#{hand(losing).join(' ')}>"
    end
  end

  def hand(strings)
    strings.map { |x| Card.from_string(x) }
  end
end
