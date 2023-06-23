require_relative 'player'
require 'pry-byebug'
class Pawn < Player
  attr_reader :symbol
  # attr_accessor :hasMoved

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♙' : @symbol = '♟︎'
    # @hasMoved = false
  end

  def possible_moves(board, simple_check)
    moves = []
    x = @position[0]
    y = @position[1]
    # if @hasMoved == false && !check_can_enemy_check_there(board, [x, new_y], simple_check)
    #   color == 'black' ? moves.push([x, y + 2]) : moves.push([x, y - 2])
    # end
    if @hasMoved == false
      color == 'black' ? new_y = y + 2 : new_y = y - 2
      if new_y.between?(0, 7)
        piece = board.get_piece_at([x, new_y])
        if piece != false
          return moves
        end
        if !check_can_enemy_check_there(board, [x, new_y], simple_check)
          moves.push([x, new_y])
        end
      end
    end
    color == 'black' ? new_y = y + 1 : new_y = y - 1
    if new_y.between?(0, 7)
      piece = board.get_piece_at([x, new_y])
      if piece != false
        return moves
      end
      if !check_can_enemy_check_there(board, [x, new_y], simple_check)
        moves.push([x, new_y])
      end
    end

    [-1, 1].each do |i|
      color == 'black' ? new_y = y + 1 : new_y = y - 1
      new_x = x + i
      if new_x.between?(0, 7) && new_y.between?(0, 7)
        piece = board.get_piece_at([new_x, new_y])
        if piece != false 
          if piece.color != color && !check_can_enemy_check_there(board, [new_x, new_y], simple_check)
            moves.push([new_x, new_y])
          end
        end
      end
    end
    return moves
  end
end
