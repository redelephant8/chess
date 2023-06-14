require_relative 'board'
require 'pry-byebug'
require_relative 'letter_to_number'

class Game
  include LetterNumber
  attr_reader :board

  def initialize
    @board = Board.new
    @selected = nil
    @b_checkmate = false
    @w_checkmate = false
  end

  def turn
    loop do
      piece, move = input_move
      add_to_board(move[1], piece)
    end
  end

  def add_to_board(move_to, piece)
    @board.change_position(piece, move_to)
    @board.print_board
  end

  def input
    puts 'Enter move: '
    input = gets.chomp
    convert_input(input)
  end

  # def input_piece
  #   puts 'Select a piece to move: '
  #   input = gets.chomp
  #   convert_piece_input(input)
  # end

  # def convert_piece_input(input)
  #   return letter_to_number(input[0], input[1].to_i - 1)
  # end

  # returns an array with the selected move and the selected square to move to
  def convert_input(input)
    initial = [letter_to_number(input[0]), input[1].to_i - 1]
    move_to = [letter_to_number(input[3]), input[4].to_i - 1]
    [initial, move_to]
  end

  # def input_move_initial
  #   selected_position = input_piece
  #   selected_piece = get_piece_selected_place(selected_position)
  #   until validate_selected_place(selected_piece)
  #     selected_position = input_piece
  #     selected_piece = get_piece_selected_place(selected_piece)
  #   end
  #   selected_piece

  # def input_move
  #   initial_piece = input_move_initial
  #   legit_moves = initial_piece.possible_moves(@board)
  #   @board.print_board_legit

  def input_move
    move = input
    piece = get_piece_selected_place(move[0])
    until validate_selected_place(piece) && validate_moving_place(move[1], piece)
      move =  input
      piece = get_piece_selected_place(move[0])
    end
    return piece, move
  end

  def check_current_pieces(piece)
    board_pieces = @board.pieces
    board_pieces.each do |board_piece|
      if board_piece == piece
        return true
      end
    end
    false
  end

  def validate_selected_place(selected_place)
    if check_current_pieces(selected_place)
      return true
    end
    false
  end

  def validate_moving_place(moving_place, piece)
    moves = piece.possible_moves(@board)
    print moves
    if moves.include?(moving_place)
      return true
    end
    false
  end

  def get_piece_selected_place(selected_place)
    pieces = @board.pieces
    pieces.each do |piece|
      if piece.position == selected_place
        return piece
      end
    end
  end
end

game = Game.new
game.board.setup_board
game.board.print_board
game.turn
