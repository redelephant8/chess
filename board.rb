# frozen_string_literal: true

require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

# class for the chess board
class Board
  attr_reader :pieces, :game_board, :piece_positions, :black_king, :white_king

  def initialize(game_board = Array.new(8) { Array.new(8) { 0 } })
    @game_board = game_board
    @pieces = []
    @piece_positions = []
    @black_king = King.new('black', [3, 0])
    @white_king = King.new('white', [3, 7])
  end

  def print_board
    place_pieces
    puts "\n \n"
    count = 8
    @game_board.reverse.each do |row|
      row.each do |cell|
        cell == 0 ? (print " #{cell} ") : (print " #{cell.symbol} ")
      end
      puts "#{count} \n"
      count -= 1
    end
    print " A  B  C  D  E  F  G  H  \n"
  end

  def place_pieces
    clear_board
    @piece_positions = []
    @pieces.each do |piece|
      print(piece)
      print(piece.position)
      x = piece.position[0]
      y = piece.position[1]
      @game_board[y][x] = piece
      @piece_positions.append(piece.position)
    end
  end

  def change_position(piece, move_to)
    if get_piece_at(move_to) != false
      enemy_piece = get_piece_at(move_to)
      delete_piece(enemy_piece)
    end
    piece.position = move_to
  end

  def delete_piece(piece)
    x = piece.position[0]
    y = piece.position[1]
    @game_board[y][x] = 0
    @pieces.delete(piece)
    
    # @pieces -= [piece]
    # @piece_positions -= [piece.position]
  end

  def clear_board
    @game_board = Array.new(8) { Array.new(8) { 0 } }
  end

  def get_piece_at(position)
    @pieces.each do |piece|
      if piece.position == position
        return piece
      end
    end
    return false
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
      # @pieces << Pawn.new('white', [i, 6])
    end
  end

end
