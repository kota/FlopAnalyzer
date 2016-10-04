require 'minitest/unit'
require 'rubygems'
require 'ruby-poker'
require './analyzer.rb'

MiniTest::Unit.autorun

class TestPokerHand < MiniTest::Unit::TestCase
  def test_oesd
    hand = PokerHand.new('4h 5d 6c 7h Td')
    assert(hand.oesd?)

    hand = PokerHand.new('9h Th Jd Ks')
    assert(!hand.oesd?)

    hand = PokerHand.new('Ad Kh Qc Js')
    assert(!hand.oesd?)

    hand = PokerHand.new('Ad 2h 3c 4s')
    assert(!hand.oesd?)
  end

  def test_gutshot
    hand = PokerHand.new('9h 7c 6d 5h 2d')
    assert(hand.gutshot?)

    hand = PokerHand.new('Qd 8h 7c 5d 4h')
    assert(hand.gutshot?)

    hand = PokerHand.new('Qd 8h 7c 6d 4h')
    assert(hand.gutshot?)

    hand = PokerHand.new('9d 7h 6c 5d 2h')
    assert(hand.gutshot?)

    hand = PokerHand.new('Ad Kh Qc Jd 8h')
    assert(hand.gutshot?,"A high gutshot")

    hand = PokerHand.new('Ad 2h 3c 4d 8h')
    assert(hand.gutshot?,"A Low gutshot")
  end
end

