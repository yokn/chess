# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'king'
require_relative 'queen'

class Board
  def initialize
    @board = Array.new(8) { Array.new(8, '-') }
  end

  def set_pieces
    set_black_backrow
    set_black_pawns
    set_white_pawns
    set_white_backrow
  end

  def get_move
    p 'Please enter the location the piece you want to move'
    old_pos = get_user_input
    p 'Please enter the location you want to move to'
    new_pos = get_user_input
    if valid_move?(old_pos, new_pos)
      move_piece(old_pos, new_pos)
    else
      p 'Invalid move. Try again.'
      get_move
    end
  end

  def valid_move?(old_pos, new_pos); end

  def to_s
    @board.each do |row|
      row.each do |slot|
        print slot == '-' ? '-' : slot.class.name[0]
        print ' '
      end
      puts ''
    end
  end

  def tie?; end

  def checkmate?; end

  private

  def get_user_input
    gets.chomp
  end

  def set_black_backrow
    @board[0][0] = Rook.new([0, 0], 'B')
    @board[0][1] = Knight.new([0, 1], 'B')
    @board[0][2] = Bishop.new([0, 2], 'B')
    @board[0][3] = Queen.new([0, 3], 'B')
    @board[0][4] = King.new([0, 4], 'B')
    @board[0][5] = Bishop.new([0, 5], 'B')
    @board[0][6] = Knight.new([0, 6], 'B')
    @board[0][7] = Rook.new([0, 7], 'B')
  end

  def set_black_pawns
    @board[1][0] = Pawn.new([0, 0], 'B')
    @board[1][1] = Pawn.new([0, 1], 'B')
    @board[1][2] = Pawn.new([0, 2], 'B')
    @board[1][3] = Pawn.new([0, 3], 'B')
    @board[1][4] = Pawn.new([0, 4], 'B')
    @board[1][5] = Pawn.new([0, 5], 'B')
    @board[1][6] = Pawn.new([0, 6], 'B')
    @board[1][7] = Pawn.new([0, 7], 'B')
  end

  def set_white_pawns
    @board[6][0] = Pawn.new([6, 0], 'W')
    @board[6][1] = Pawn.new([6, 1], 'W')
    @board[6][2] = Pawn.new([6, 2], 'W')
    @board[6][3] = Pawn.new([6, 3], 'W')
    @board[6][4] = Pawn.new([6, 4], 'W')
    @board[6][5] = Pawn.new([6, 5], 'W')
    @board[6][6] = Pawn.new([6, 6], 'W')
    @board[6][7] = Pawn.new([6, 7], 'W')
  end

  def set_white_backrow
    @board[7][0] = Rook.new([7, 0], 'W')
    @board[7][1] = Knight.new([7, 1], 'W')
    @board[7][2] = Bishop.new([7, 2], 'W')
    @board[7][3] = Queen.new([7, 3], 'W')
    @board[7][4] = King.new([7, 4], 'W')
    @board[7][5] = Bishop.new([7, 5], 'W')
    @board[7][6] = Knight.new([7, 6], 'W')
    @board[7][7] = Rook.new([7, 7], 'W')
  end
end
