require 'card'
require 'fileutils'

module HighCard
  DEFAULT_LOGIN = `whoami`.chomp

  def self.beats?(hand, opposing)
    winning  = [hand, opposing]
      .sort_by {|h| h.map(&:rank).sort.reverse }
      .last
    hand == winning
  end

  class CLI
    def self.run(seed=rand(100000), *args)
      Kernel.srand seed.to_i

      ranks = (7..10).to_a + [:jack, :queen, :king]
      suits = [:hearts, :clubs, :diamonds, :spades]

      deck = ranks.product(suits).map do |rank, suit|
        Card.build(suit, rank)
      end.shuffle

      login = DEFAULT_LOGIN
      bank = Bank.new(ENV.fetch('HIGHCARD_DIR', "/tmp/bank-accounts"))
      account = bank.accounts.detect {|x| x.name == login }
      if !account
        puts "Could not find bank account, you cannot play"
        return
      end

      hand     = deck.shift(5).sort_by(&:rank).reverse
      opposing = deck.shift(5).sort_by(&:rank).reverse
      winning  = [hand, opposing]
        .sort_by {|h| h.map(&:rank).sort.reverse }
        .last

      puts "Your hand is       #{hand.join(", ")}"
      print "Bet $1 to win? N/y: "
      start = Time.now
      input = $stdin.gets
      if (input.chomp.downcase == "y") ^ (opposing == winning)
        puts "You won!"
        account.credit!(login, 1)
      else
        puts "You lost!"
        account.debit!(login, 1)
      end
      puts "Opposing hand was  #{opposing.join(", ")}"
      puts "Balance is #{account.balance}"
      puts "You took #{Time.now - start}s to make a decision."
    end
  end

  class Bank
    class Account
      attr_reader :name, :balance

      def initialize(path, name)
        @path = path
        FileUtils.mkdir_p(path)
        @name = name
        @balance = File.read(path + "/#{name}").to_i rescue 0
      end

      def debit!(account, amount)
        raise if account != name
        @balance -= amount
        write!
      end

      def credit!(account, amount)
        raise if account != name
        @balance += amount
        write!
      end

      private

      def write!
        File.write(@path + "/#{name}", balance)
      end
    end

    def initialize(path)
      @path = path
    end

    def accounts
      [Account.new(@path, DEFAULT_LOGIN)]
    end
  end
end