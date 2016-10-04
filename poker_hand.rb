require 'rubygems'
require 'ruby-poker'

class PokerHand

  #TODO draw系の判定
  def gutshot_draw?
  end

  def double_belly_buster_draw?
  end

  def flush?
    if (md = (by_suit =~ /(.)(.) (.)\2 (.)\2 (.)\2 (.)\2/))
      puts "*" * 100
      puts md
      puts "*" * 100
      [
        [
          6,
          Card::face_value(md[1]),
          *(md[3..6].map { |f| Card::face_value(f) })
        ],
        arrange_hand(md)
      ]
    else
      false
    end
  end
end
