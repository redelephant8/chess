require_relative 'player'

class Rook < Player

  attr_reader :symbol

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♜' : @symbol = '♖'
    @POSSIBILITIES = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end