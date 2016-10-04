require 'minitest/unit'
require './hand_range.rb'

MiniTest::Unit.autorun

class TestHandRange < MiniTest::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_pair
    range = HandRange.new('QQ')
    assert_equal(6, range.hands.size)
    range.hands.each do |hand|
      assert_equal(hand.face_values[0], hand.face_values[1])
      assert(hand.hand[0].suit != hand.hand[1].suit)
    end
  end

  def test_non_pair_suited_or_unsuited_hand
    range = HandRange.new('76')
    assert_equal(16, range.hands.size)
    suited_count = 0
    off_suit_count = 0

    range.hands.each do |hand|
      assert_equal(6, hand.by_face.face_values[0])
      assert_equal(5, hand.by_face.face_values[1])
      if hand.hand[0].suit == hand.hand[1].suit
        suited_count += 1
      else
        off_suit_count += 1
      end
    end

    assert_equal(4, suited_count)
    assert_equal(12, off_suit_count)
  end

  def test_non_pair_suited
    range = HandRange.new('T5s')
    assert_equal(4, range.hands.size)
    range.hands.each do |hand|
      assert(hand.hand[0].suit == hand.hand[1].suit)
    end
  end

  def test_non_pair_off_suited
    range = HandRange.new('T5o')
    assert_equal(12, range.hands.size)
    range.hands.each do |hand|
      assert(hand.hand[0].suit != hand.hand[1].suit)
    end
  end

end
