require 'spec_helper'
require 'pty'
require 'tmpdir'
require 'high_card'

BIN = File.expand_path('../bin/play', __dir__)
describe 'CLI', :acceptance do
  example 'it works' do
    PTY.spawn(BIN) do |output, input, _pid|
      sleep 0.5
      input.puts('y/n')
      sleep 0.5

      buffer = output.read_nonblock(1024)
      expect(buffer).to include('You won').or include('You lost')
    end
  end

  example 'betting on winning card' do
    PTY.spawn(BIN) do |output, input, _pid|
      sleep 0.5
      input.puts('y')
      sleep 0.5

      buffer = output.read_nonblock(1024)
      expect(buffer).to include('You won').or include('You lost')
    end
  end

  class FakeAccount
    def name
      'root'
    end

    def credit!(*_); end

    def debit!(*_); end

    def balance; end
  end

  example 'not betting on losing hand' do
    # External dependencies
    allow(HighCard::CLI).to receive(:puts)
    allow(HighCard::CLI).to receive(:print)

    allow_any_instance_of(HighCard::Bank).to receive(:accounts).and_return([
      FakeAccount.new
    ])

    # Set up a state
    allow(Card).to receive(:build).and_return(*
      [Card.build(:clubs, 7)] * 5 +
      [Card.build(:clubs, 8)] * 5)
    allow_any_instance_of(Array).to receive(:shuffle) { |x| x }

    expect($stdin).to receive(:gets).and_return('N')
    expect(HighCard::CLI).to receive(:puts).with('You won!')

    HighCard::CLI.run
  end
end
