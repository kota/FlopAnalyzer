require 'rubygems'
require 'ruby-poker'

class HandRange
  attr_reader :hands

  SUITS = %w(s h d c)

  def initialize(range)
    @hands = []
    range.gsub(" ", "").split(',').each do |cards|
      @hands += generate_hands(cards)
    end
  end

  def generate_hands(cards)
    hands = []
    if cards.size == 2
      if cards[0] == cards[1] #pair e.g. 'QQ'
        SUITS.combination(2).to_a.each do |suit_combo|
          hands << PokerHand.new("#{cards[0]}#{suit_combo[0]}#{cards[1]}#{suit_combo[1]}")
        end
      else # suited and offsuit. e.g. '76'
        SUITS.each do |suit1|
          SUITS.each do |suit2|
            hands << PokerHand.new("#{cards[0]}#{suit1}#{cards[1]}#{suit2}")
          end
        end
      end
    elsif cards.size == 3
      if cards[2] == 's' # suited e.g. '76s'
        SUITS.each do |suit|
          hands << PokerHand.new("#{cards[0]}#{suit}#{cards[1]}#{suit}")
        end
      elsif cards[2] == 'o' # off suited e.g. '76o'
        SUITS.each do |suit1|
          SUITS.each do |suit2|
            next if suit1 == suit2
            hands << PokerHand.new("#{cards[0]}#{suit1}#{cards[1]}#{suit2}")
          end
        end
      else 
        raise "invalid hand format #{cards}"
      end
    else
      raise "invalid hand format #{cards}"
    end

    hands
  end
end
