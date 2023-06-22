
require_relative 'board'
require 'pry-byebug'

class Player

  attr_reader :color
  attr_accessor :position

  def initialize(color, position = nil)
    @color = color
    @position = position
  end


  def check_can_enemy_check_there(board, potential_move, simple_check)
    if simple_check == true
      return false
    end
    original_position = self.position
    pieces = board.pieces
    updated_board = Board.new
    pieces.each do |piece|
      updated_board.pieces.append(piece)
    end
    piece_at_move = board.get_piece_at(potential_move)
    if piece_at_move != false
      updated_board.pieces.delete(piece_at_move)
    end
    self.position = potential_move
    updated_board.pieces.append(self)
    updated_board.place_pieces

    enemy_pieces = updated_board.pieces
    king_position = board.white_king.position
    if color == 'black'
      king_position = board.black_king.position
    end
    enemy_pieces.each do |piece|
      if piece.color != color && !piece.is_a?(King)
        moves = piece.possible_moves(updated_board, true)
        # print moves
        if moves.include?(king_position)
          # print "yes"
          self.position = original_position
          # binding.pry
          return true
        end
      end
    end
    # print "nonononononon"
    self.position = original_position
    return false
  end
end
