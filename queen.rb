require_relative 'player'
require 'pry-byebug'
class Queen < Player
  attr_reader :symbol

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♕' : @symbol = '♛'
    @possibilities = [[0,-1], [0, 1], [-1, 0], [1, 0], [-1, -1], [-1, 1], [1, -1], [1, 1]]
  end

  def possible_moves(board, simple_check)
    moves = []
    x = @position[0]
    y = @position[1]
    # binding.pry
    @possibilities.each do |movement|
      (1..7).each do |i|
        new_x = x + (i * movement[0])
        new_y = y + (i * movement[1])
        if new_x.between?(0, 7) && new_y.between?(0, 7) && !check_can_enemy_check_there(board, [new_x, new_y], simple_check)
          if board.piece_positions.include?([new_x, new_y])
            piece = board.get_piece_at([new_x, new_y])
            if piece.color != color
              moves.push([new_x, new_y])
            end
            break
          end
          if !board.piece_positions.include?([new_x, new_y])
            moves.push([new_x, new_y])
          end
        end
      end
    end
    return moves
  end
end
