# frozen_string_literal: true

require_relative 'rook'

class Board
  attr_reader :game_board

  def initialize(game_board = Array.new(8) { Array.new(8) { 0 } })
    @game_board = game_board
    @pieces = Array.new
  end

  def print_board
    place_pieces
    puts "\n \n"
    @game_board.each do |row|
      row.each do |cell|
        cell == 0 ? (print " #{cell} ") : (print " #{cell.symbol} ")
      end
      puts "\n"
    end
  end

  def place_pieces
    @pieces.each do |piece|
      y = piece.position[0]
      x = piece.position[1]
      @game_board[y][x] = piece
    end
  end

  def setup_board
    @pieces << Rook.new('black', [0, 0])
    @pieces << Rook.new('black', [0, 7])
    @pieces << Rook.new('white', [7, 0])
    @pieces << Rook.new('white', [7, 7])
  end

end
