require_relative 'player'
require 'pry-byebug'
class Pawn < Player
  attr_reader :symbol, :pawn_promotion, :en_passant

  def initialize(color, position)
    super
    color == 'black' ? @symbol = '♙' : @symbol = '♟︎'
    @pawn_promotion = []
    @en_passant = []
  end

  def possible_moves(board, simple_check)
    moves = []
    @pawn_promotion = []
    @en_passant = []
    x = @position[0]
    y = @position[1]
    if @hasMoved == false
      color == 'black' ? new_y = y + 2 : new_y = y - 2
      if new_y.between?(0, 7)
        piece = board.get_piece_at([x, new_y])
        if !piece && !check_can_enemy_check_there(board, [x, new_y], simple_check)
          moves.push([x, new_y])
        end
      end
    end
    color == 'black' ? new_y = y + 1 : new_y = y - 1
    if new_y.between?(0, 7)
      piece = board.get_piece_at([x, new_y])
      if !piece && !check_can_enemy_check_there(board, [x, new_y], simple_check)
        if new_y == 7 || new_y == 0
          @pawn_promotion.push([self, [x, new_y]])
        end
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
            if new_y == 7 || new_y == 0
              @pawn_promotion.push([self, [new_x, new_y]])
            end
            moves.push([new_x, new_y])
          end
        end
      end
    end

    if board.last_prepped_en_passant_pawn != nil
      color == 'black' ? new_y = y + 1 : new_y = y - 1
      prepped_pawn = board.last_prepped_en_passant_pawn
      new_x = prepped_pawn.position[0]
      current_x = @position[0]
      if new_x - current_x == 1 || current_x - new_x == 1
        if new_x.between?(0, 7) && new_y.between?(0, 7)
          if prepped_pawn.color != color && !check_can_enemy_check_there(board, [new_x, new_y], simple_check)
            @en_passant.push([self, [new_x, new_y]])
            moves.push([new_x, new_y])
          end
        end
      end
    end
    return moves
  end
end
