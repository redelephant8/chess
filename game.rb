require_relative 'board'
require 'pry-byebug'
require_relative 'letter_to_number'

class Game
  include LetterNumber
  attr_reader :board

  def initialize
    @board = Board.new
    @selected = nil
    @black_check = false
    @white_check = false
    @black_checkmate = false
    @white_checkmate = false
    @turn = 'black'
  end

  def turn
    loop do
      @black_check = false
      @white_check = false
      checkCheck(@board)
      switch_turn
      # binding.pry
      piece, move = input_move
      add_to_board(move[1], piece)
    end
  end

  def switch_turn
    @turn == 'black' ? @turn = 'white' : @turn = 'black'
  end

  def add_to_board(move_to, piece)
    @board.change_position(piece, move_to)
    @board.print_board
  end

  def input
    puts @turn.capitalize + ', enter move: '
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
      if board_piece == piece && piece.color == @turn
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
    moves = piece.possible_moves(@board, false)
    print moves
    # print moves
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

  def checkCheck(board)
    pieces = board.pieces
    white_king_position = board.white_king.position
    black_king_position = board.black_king.position
    pieces.each do |piece|
      moves = piece.possible_moves(board, true)
      if moves.include?(white_king_position)
        print "Check on White"
        @white_check = true
      end
      if moves.include?(black_king_position)
        print "Check on Black"
        @black_check = true
      end
    end
  end

  # def can_black_evade_check(potential_move)
  #   original_piece = get_piece_selected_place(potential_move)
  #   updated_board = Board.new
  #   pieces = @board.pieces
  #   pieces.each do |piece|
  #     updated_board.pieces.append(piece)
  #   end
  # end

  # def duplicate_board_for_check_check
  # end

  # def will_there_be_check(board, potential_move)
  #   enemy_pieces = board.pieces
  #   enemy_pieces.each do |piece|
  #     if piece.color != @turn && !piece.is_a?(King)
  #       moves = piece.possible_moves(board, false)
  #       if moves.include?(potential_move)
  #         return true
  #       end
  #     end
  #   end
  #   return false
  # end
  

end

game = Game.new
game.board.setup_board
game.board.print_board
game.turn
