# frozen_string_literal: true

require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

# class for the chess board
class Board
  attr_reader :pieces, :game_board, :last_prepped_en_passant_pawn
  attr_accessor :black_king, :white_king

  def initialize(game_board = Array.new(8) { Array.new(8) { "□" } })
    @game_board = game_board
    (0..7).each do |row|
      (0..7).each do |cell|
        if ((row+1) * (cell+1)) % 2 == 0
          @game_board[row][cell] = "□"
        else
          @game_board[row][cell] = "◼"
        end
      end
    end
    @pieces = []
    @black_king = King.new('black', [3, 0])
    @white_king = King.new('white', [3, 7])
    @last_prepped_en_passant_pawn = nil
  end

  def print_board
    place_pieces
    puts "\n \n"
    count = 8
    @game_board.reverse.each do |row|
      row.each do |cell|
        if cell == "□" || cell == "◼"
          print " #{cell} "
        else
          print " #{cell.symbol} "
        end
      end
      puts "#{count} \n"
      count -= 1
    end
    print " A  B  C  D  E  F  G  H  \n"
  end

  def place_pieces
    clear_board
    # binding.pry
    @pieces.each do |piece|
      x = piece.position[0]
      y = piece.position[1]
      @game_board[y][x] = piece
    end
  end

  def change_position(piece, move_to)
    if get_piece_at(move_to) != false
      enemy_piece = get_piece_at(move_to)
      delete_piece(enemy_piece)
    end
    castling(piece, move_to)
    en_passant(piece, move_to)
    check_prep_for_passant(piece, move_to)
    new_piece = pawn_promotion(piece, move_to)
    if new_piece != nil
      delete_piece(piece)
      @pieces.push(new_piece)
    else
      piece.position = move_to
    end
  end

  def castling(piece, move_to)
    if piece.is_a?(King) && piece.castling != []
      piece.castling.each do |castle_movement|
        if castle_movement[1] == move_to
          rook = castle_movement[0]
          rook.position = castle_movement[2]
        end
      end
    end
  end

  def check_prep_for_passant(piece, move_to)
    if piece.is_a?(Pawn)
      current_y = piece.position[1]
      new_y = move_to[1]
      if new_y - current_y == 2 || current_y - new_y == 2
        @last_prepped_en_passant_pawn = piece
        return
      end
    end
    @last_prepped_en_passant_pawn = nil
  end

  def en_passant(piece, move_to)
    if piece.is_a?(Pawn) && @last_prepped_en_passant_pawn != nil && piece.en_passant != []
      piece.en_passant.each do |pawn_movement|
        if pawn_movement[1] == move_to
          delete_piece(last_prepped_en_passant_pawn)
          break
        end
      end
    end
  end

  def pawn_promotion(piece, move_to)
    new_piece = nil
    if piece.is_a?(Pawn) 
      # binding.pry
      piece.pawn_promotion.each do |pawn_movement|
        if pawn_movement != [] && move_to == pawn_movement[1]
          position = piece.position
          color = piece.color
          puts "Enter the piece type you want to promote to: (B, K, R, Q):"
          promotion = gets.chomp
          case promotion
          when 'B'
            new_piece = Bishop.new(color, move_to)
          when 'K'
            new_piece = Knight.new(color, move_to)
          when 'R'
            new_piece = Rook.new(color, move_to)
          when 'Q'
            new_piece = Queen.new(color, move_to)
          end
        return new_piece
        end
      end
    end
    return new_piece
  end

  def delete_piece(piece)
    x = piece.position[0]
    y = piece.position[1]
    @game_board[y][x] = 0
    @pieces.delete(piece)
  end

  def clear_board
    @game_board = Array.new(8) { Array.new(8) { 0 } }
    (0..7).each do |row|
      (0..7).each do |cell|
        if ((row+1) + (cell+1)) % 2 == 0
          @game_board[cell][row] = "□"
        else
          @game_board[cell][row] = "◼"
        end
      end
    end
  end

  def get_piece_at(position)
    @pieces.each do |piece|
      if piece.position == position
        return piece
      end
    end
    return false
  end

  def get_rooks(color)
    rooks = []
    @pieces.each do |piece|
      if piece.is_a?(Rook) && piece.color == color
        rooks.append(piece)
      end
    end
    return rooks
  end

  def update_pieces(piece)
    x = piece.position[0]
    y = piece.position[1]
    @game_board[y][x] = piece.symbol
  end

  def setup_board
    @pieces << Rook.new('black', [0, 0])
    @pieces << Rook.new('black', [7, 0])
    @pieces << Rook.new('white', [0, 7])
    @pieces << Rook.new('white', [7, 7])
    @pieces << Knight.new('black', [1, 0])
    @pieces << Knight.new('black', [6, 0])
    @pieces << Knight.new('white', [1, 7])
    @pieces << Knight.new('white', [6, 7])
    @pieces << Bishop.new('black', [2, 0])
    @pieces << Bishop.new('black', [5, 0])
    @pieces << Bishop.new('white', [2, 7])
    @pieces << Bishop.new('white', [5, 7])
    @pieces << Queen.new('black', [4, 0])
    @pieces << Queen.new('white', [4, 7])
    @pieces << @black_king
    @pieces << @white_king
    (0..7).each do |i|
      @pieces << Pawn.new('black', [i, 1])
      @pieces << Pawn.new('white', [i, 6])
    end
  end

end
