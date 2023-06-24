require_relative 'player'
class King < Player
  attr_reader :symbol, :castling

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♔' : @symbol = '♚'
    @possibilities = [[0,-1], [0, 1], [-1, 0], [1, 0], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    @castling = []
  end


  def possible_moves(board, simple_check)
    moves = []
    @castling = []
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

      if @hasMoved == false
        x = @position[0]
        y = @position[1]
        rooks = board.get_rooks(@color)
        rooks.each do |rook|
          if rook.hasMoved == false
            if rook.position[0] == 0 && board.get_piece_at([x - 1, y]) == false && board.get_piece_at([x - 2, y]) == false
              if !check_can_enemy_check_there(board, [x - 1, y], simple_check) && !check_can_enemy_check_there(board, [x - 2, y], simple_check)
                moves.push([x - 2, y])
                @castling.push([rook, [x - 2, y], [x - 1, y]])
              end
            end
            if rook.position[0] == 7 && board.get_piece_at([x + 1, y]) == false && board.get_piece_at([x + 2, y]) == false
              if !check_can_enemy_check_there(board, [x + 1, y], simple_check) && !check_can_enemy_check_there(board, [x + 2, y], simple_check)
                moves.push([x + 2, y])
                @castling.push([rook, [x + 2, y], [x + 1, y]])
              end
            end
          end
        end
      end
    return moves
  end


    # TODO: add forced check if other king is nearby / vicinity of 1 block
    def check_can_enemy_check_there_king(board, potential_move)
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