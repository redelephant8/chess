# frozen_string_literal: true

require_relative 'rook'

class Board
  attr_reader :pieces, :game_board

  def initialize(game_board = Array.new(8) { Array.new(8) { 0 } })
    @game_board = game_board
    @pieces = Array.new
  end

  def print_board
    clear_board
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
    @pieces.each do |piece|
      y = piece.position[1]
      x = piece.position[0]
      @game_board[y][x] = piece
    end
  end

  def change_position(piece, move_to)
    piece.position = move_to
  end

  def delete_piece(piece)
    x = piece.position[1]
    y = piece.position[0]
    @game_board[y][x] = 0
    @pieces.delete(piece)
  end

  def clear_board
    @game_board = Array.new(8) { Array.new(8) { 0 } }
  end

  def update_pieces(piece)
    y = piece.position[0]
    x = piece.position[1]
    @game_board[y][x] = piece.symbol
  end

  def setup_board
    @pieces << Rook.new('black', [0, 0])
    @pieces << Rook.new('black', [7, 0])
    @pieces << Rook.new('white', [0, 7])
    @pieces << Rook.new('white', [7, 7])
    # @pieces << Rook.new('black', [])
  end

end
