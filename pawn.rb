
class Pawn < Player
  attr_reader :symbol
  
  def initialize(color)
    @symbol = symbol
    @color = color
  end
end