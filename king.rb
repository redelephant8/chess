require_relative 'player'
require 'pry-byebug'
class King < Player
  attr_reader :symbol

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♔' : @symbol = '♚'
    @possibilities = [[0,-1], [0, 1], [-1, 0], [1, 0], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @check = false
  end

  def possible_moves(board, simple_check)
    moves = []
    x = @position[0]
    y = @position[1]
    # binding.pry
    @possibilities.each do |movement|
        new_x = x + movement[0]
        new_y = y + movement[1]
        if new_x.between?(0, 7) && new_y.between?(0, 7)
            if board.piece_positions.include?([new_x, new_y]) && !check_can_enemy_check_there_king(board, [new_x, new_y], simple_check)
              piece = board.get_piece_at([new_x, new_y])
              if piece.color != color
                moves.push([new_x, new_y])
              end
            end
            if !board.piece_positions.include?([new_x, new_y]) && !check_can_enemy_check_there_king(board, [new_x, new_y], simple_check)
                moves.push([new_x, new_y])
            end
        end
    end
    return moves
    end


    # TODO: add forced check if other king is nearby / vicinity of 1 block
    def check_can_enemy_check_there_king(board, potential_move, simple_check)
      enemy_pieces = board.pieces
      enemy_pieces.each do |piece|
        if piece.color != color && !piece.is_a?(King)
          moves = piece.possible_moves(board, true)
          if moves.include?(potential_move)
            return true
          end
        end
      end
      return false
    end
end