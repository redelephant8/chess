require_relative 'player'
require 'pry-byebug'
class Knight < Player
  attr_reader :symbol

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♘' : @symbol = '♞'
    @possibilities = [[1, 2], [2, 1], [-1, 2], [1, -2], [-2, 1], [2, -1], [-1, -2], [-2, -1]]
  end

  def possible_moves(board, simple_check)
    moves = []
    x = @position[0]
    y = @position[1]
    # binding.pry
    @possibilities.each do |movement|
        new_x = x + movement[0]
        new_y = y + movement[1]
        if new_x.between?(0, 7) && new_y.between?(0, 7) && !check_can_enemy_check_there(board, [new_x, new_y], simple_check)
            if board.piece_positions.include?([new_x, new_y])
              piece = board.get_piece_at([new_x, new_y])
              if piece.color != color
                moves.push([new_x, new_y])
              end
            end
            if !board.piece_positions.include?([new_x, new_y])
                moves.push([new_x, new_y])
            end
        end
    end
    return moves
    end
end