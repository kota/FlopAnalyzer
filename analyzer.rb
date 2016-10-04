require 'rubygems'
require 'ruby-poker'
require './hand_range.rb'

PokerHand.allow_duplicates = false

class PokerHand
  OPS = [
    ['Royal Flush',     :royal_flush? ],
    ['Straight Flush',  :straight_flush? ],
    ['Four of a kind',  :four_of_a_kind? ],
    ['Full house',      :full_house? ],
    ['Flush',           :flush? ],
    ['Straight',        :straight? ],
    ['Three of a kind', :three_of_a_kind?],
    ['Two pair',        :two_pair? ],
    ['Pair',            :pair? ],
    ['Flush Draw',      :flush_draw? ],
    ['OESD',      :oesd? ],
    ['Gutshot',      :gutshot? ],
    ['Highest Card',    :highest_card? ],
    ['Empty Hand',      :empty_hand? ],
  ]

  def flush_draw?
    if (md = (by_suit =~ /(.)(.) (.)\2 (.)\2 (.)\2 /))
      [
        [
          1.1,
          Card::face_value(md[1]),
          *(md[3..5].map { |f| Card::face_value(f) })
        ],
        arrange_hand(md)
      ]
    else
      false
    end
  end

  def oesd?
    return false if straight? || straight_flush?

    if hand.size >= 4
      transform = delta_transform
      # note we can have more than one delta 0 that we
      # need to shuffle to the back of the hand
      i = 0
      until transform.match(/^\S{3}( [1-9x]\S\S)+( 0\S\S)*$/) or i >= hand.size  do
        # only do this once per card in the hand to avoid entering an
        # infinite loop if all of the cards in the hand are the same
        transform.gsub!(/(\s0\S\S)(.*)/, "\\2\\1")    # moves the front card to the back of the string
        i += 1
      end
      if (md = (/.(.). 1.. 1.. 1../.match(transform)))
        high_card = Card::face_value(md[1])
        return false if high_card == 13 || high_card == 3
        arranged_hand = fix_low_ace_display(md[0] + ' ' + md.pre_match + ' ' + md.post_match)
        return [[1.9, high_card], arranged_hand]
      end
    end
    false
  end

  def gutshot?
    return false if straight? || straight_flush?

    if hand.size >= 4
      transform = delta_transform
      # note we can have more than one delta 0 that we
      # need to shuffle to the back of the hand
      i = 0
      until transform.match(/^\S{3}( [1-9x]\S\S)+( 0\S\S)*$/) or i >= hand.size  do
        # only do this once per card in the hand to avoid entering an
        # infinite loop if all of the cards in the hand are the same
        transform.gsub!(/(\s0\S\S)(.*)/, "\\2\\1")    # moves the front card to the back of the string
        i += 1
      end
      if (md = (/(.(.). 2.. 1.. 1..)|(.(.). 1.. 2.. 1..)|(.(.). 1.. 1.. 2..)|(0A. 1K. 1Q. 1J.)|(.4. 13. 12. 1L.)/.match(transform)))
        high_card = Card::face_value(md[1] || md[3] || md[5] || 'A')
        arranged_hand = fix_low_ace_display(md[0] + ' ' + md.pre_match + ' ' + md.post_match)
        return [[1.8, high_card], arranged_hand]
      end
    end
    false
  end
end

class FlopAnalyzer
  
  def initialize(flop)
    @flop = PokerHand.new(flop)
  end

  def analyze(range)
    results = {}
    range.hands.each do |hole_cards|
      hand = PokerHand.new(@flop.just_cards)
      begin
        hand << hole_cards
      rescue => e
        next
      end
      results[hand.hand_rating] ||= []
      results[hand.hand_rating] << hole_cards.by_face.just_cards
    end

    results
  end
end

range = HandRange.new('AA,KK,QQ,AKs,AQs,98s,67s,33,T9s,QJo')
analyzer = FlopAnalyzer.new("As 8s 9s")
puts analyzer.analyze(range)
