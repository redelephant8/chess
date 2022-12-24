require_relative 'board'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
    @selected = nil
  end

  # def select_piece(y, x)
  #   @selected = @board[y, x]
  #   # possibilities = Array.new
  #   move_piece
  # end

  # def move_piece(y, x)
  #   previous = @selected.position
  #   @board[y, x] = @selected
  #   @board[previous] = 0
  # end



end

game = Game.new
game.board.setup_board
game.board.print_board
