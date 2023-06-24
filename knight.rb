require_relative 'player'
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
    @possibilities.each do |movement|
        new_x = x + movement[0]
        new_y = y + movement[1]
        if new_x.between?(0, 7) && new_y.between?(0, 7)
          piece = board.get_piece_at([new_x, new_y])
          if piece != false
            if piece.color != color && !check_can_enemy_check_there(board, [new_x, new_y], simple_check)
              moves.push([new_x, new_y])
            end
          else
            if !check_can_enemy_check_there(board, [new_x, new_y], simple_check)
              moves.push([new_x, new_y])
            end
          end
        end
    end
    return moves
    end
end