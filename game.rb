require_relative 'board'
require 'pry-byebug'
require_relative 'letter_to_number'

class Game
  include LetterNumber
  attr_reader :board

  def initialize
    @board = Board.new
    @black_check = false
    @white_check = false
    @turn = 'black'
  end

  def turn
    loop do
      @black_check = false
      @white_check = false
      switch_turn
      piece, move = input_move
      add_to_board(move[1], piece)
      checkCheck(@board)
      if (@black_check && can_black_evade_check(@board) == false) || (@white_check && can_white_evade_check(@board) == false)
        break
      end
    end
  end

  def switch_turn
    @turn == 'black' ? @turn = 'white' : @turn = 'black'
  end

  def add_to_board(move_to, piece)
    @board.change_position(piece, move_to)
    if piece.hasMoved == false
      piece.hasMoved = true
    end
    @board.print_board
  end

  def print_possible_moves(moves)
    written_moves = ""
    moves.each do |move|
      written_moves += "#{number_to_letter(move[0])}#{move[1] + 1}, "
    end
    return written_moves.slice(0, written_moves.length - 2)
  end

  def input_move
    chosen_initial_coordinates, chosen_piece = input_initial
    moves = chosen_piece.possible_moves(@board, false)
    moves == [] ? empty_moves = true : empty_moves = false
    if empty_moves
      puts "No moves available for this piece"
    end
    written_moves = print_possible_moves(moves)
    if !empty_moves
      chosen_final_coordinates = input_coordinates(1, written_moves)
      own_piece = check_if_own_piece(chosen_final_coordinates)
    end
    until !empty_moves && !own_piece && validate_final_coordinates(chosen_final_coordinates, moves)
      if own_piece || empty_moves
        chosen_initial_coordinates, chosen_piece = own_piece
        if empty_moves
          chosen_initial_coordinates, chosen_piece = input_initial
        end
        moves = chosen_piece.possible_moves(@board, false)
        moves == [] ? empty_moves = true : empty_moves = false
        if empty_moves
          puts "No moves available for this piece"
        end
        written_moves = print_possible_moves(moves)
      end
      if !empty_moves
        chosen_final_coordinates = input_coordinates(1, written_moves)
        own_piece = check_if_own_piece(chosen_final_coordinates)
      end
    end
    return chosen_piece, [chosen_initial_coordinates, chosen_final_coordinates]
  end

  def input_initial
    chosen_initial_coordinates = input_coordinates(0, nil)
    chosen_piece = @board.get_piece_at(chosen_initial_coordinates)
    until validate_initial_piece(chosen_piece)
      chosen_initial_coordinates = input_coordinates(0, nil)
      chosen_piece = @board.get_piece_at(chosen_initial_coordinates)
    end
    return chosen_initial_coordinates, chosen_piece
  end

  def input_coordinates(x, moves)
    if x == 0
      puts @turn.capitalize + ', select piece to move'
    else
      puts @turn.capitalize + ', select place to move to. Options: ['+ moves +']'
    end
    input = gets.chomp
    initial = [letter_to_number(input[0]), input[1].to_i - 1]
    return initial
  end

  def check_if_own_piece(chosen_final_coordinates)
    piece_at_final_coordinates = @board.get_piece_at(chosen_final_coordinates)
    if validate_initial_piece(piece_at_final_coordinates)
      return chosen_final_coordinates, piece_at_final_coordinates
    end
    return false
  end

  def validate_final_coordinates(chosen_final_coordinates, moves)
    if moves.include?(chosen_final_coordinates)
      return true
    end
    return false
  end
      
  def validate_initial_piece(piece)
    board_pieces = @board.pieces
    board_pieces.each do |board_piece|
      if board_piece == piece && piece.color == @turn
        return true
      end
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
        puts "Check on White"
        @white_check = true
      end
      if moves.include?(black_king_position)
        puts "Check on Black"
        @black_check = true
      end
    end
  end

  def can_black_evade_check(board)
    pieces = board.pieces
    pieces.each do |piece|
      if piece.color == 'black'
        moves = piece.possible_moves(board, false)
        if moves != []
          return true
        end
      end
    end
    return false
  end

  def can_white_evade_check(board)
    pieces = board.pieces
    pieces.each do |piece|
      if piece.color == 'white'
        moves = piece.possible_moves(board, false)
        if moves != []
          return true
        end
      end
    end
    return false
  end
end

def begin_game
  game = Game.new
  game.board.setup_board
  game.board.print_board
  game.turn
end
