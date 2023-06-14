require_relative 'player'
require 'pry-byebug'
class Pawn < Player
  attr_reader :symbol

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♙' : @symbol = '♟︎'
    @hasMoved = false
  end

  def possible_moves(board)
    moves = []
    x = @position[0]
    y = @position[1]
    color == 'black' ? new_y = y + 1 : new_y = y - 1
    if @hasMoved == false
      color == 'black' ? moves.push([x, y + 2]) : moves.push([x, y - 2])
      @hasMoved = true
    end
    if new_y.between?(0, 7)
      if !(board.piece_positions.include?([x, new_y]))
        moves.push([x, new_y])
        @hasMoved = true
      end
    end
    [-1, 1].each do |i|
      new_x = x + i
      if new_x.between?(0, 7) && new_y.between?(0, 7)
        if board.piece_positions.include?([new_x, new_y])
          piece = board.get_piece_at([new_x, new_y])
          if piece.color != color
            moves.push([new_x, new_y])
            @hasMoved = true
          end
        end
      end
    end
    return moves
  end
end
