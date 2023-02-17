require_relative 'player'

class Rook < Player
  attr_reader :symbol

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♖' : @symbol = '♜'
    @possibilities = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end

  def possible_moves(board)
    moves = []
    x = @position[1]
    y = @position[0]
    for movement in @possibilities
      for i in 1..7
        new_x = x + (i * movement[1])
        new_y = y + (i * movement[0])
        if new_x.between?(0, 7) && new_y.between?(0, 7)
          if !(board.pieces.include?([new_y, new_x]))
            moves.push([new_y, new_x])
          elsif board.pieces[new_y, new_x].color != color
            moves.push([new_y, new_x])
          end
        end
      end
    end
    return moves
  end
end
