# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Board
  def initialize
    @board = Array.new(8) { Array.new(8, '-') }
  end

  def set_pieces
    set_black_backrow
    set_black_pawns
    set_white_pawns
    set_white_backrow
    generator
  end

  # Make the knight N maybe?
  def to_s
    @board.each do |row|
      row.each do |tile|
        print tile == '-' ? '-' : tile.class.name[0]
        print ' '
      end
      puts ''
    end
  end

  # do we need the += here anymore?
  def get_move(old_pos = [], new_pos = [])
    p 'Please enter the location of the piece you wish to move in algebraic notation'
    old_pos += Translator.to_matrix(get_user_input)
    return invalid_move if empty_tile?(old_pos)

    display_available_moves(old_pos)

    p 'Please enter the location you wish to move to in algebraic notation'
    new_pos += Translator.to_matrix(get_user_input)
    # this might need an explicit return invalid_move as well
    valid_move?(old_pos, new_pos) ? make_move(old_pos, new_pos) : invalid_move
  end

  def tie?; end

  def checkmate?; end

  private

  def empty_tile?(old_pos)
    @board[old_pos[0].to_i][old_pos[1].to_i] == '-'
  end

  def invalid_move
    p 'Invalid move. Try again.'
    get_move
  end

  def display_available_moves(old_pos)
    puts 'available moves:'
    @board[old_pos[0].to_i][old_pos[1].to_i].available_moves.each do |move|
      print Translator.to_algebraic(move) + ' '
    end
    puts ''
  end

  def generator
    @board.each do |row|
      row.each do |tile|
        next if tile == '-'

        tile.level_order(tile.position, @board)
        # p "working on piece: #{tile.color} #{tile.class.name}"
        tile.level_order(tile.position, @board)
      end
    end
  end

  # need input validation on the new_pos or this throws an error
  # needs to make sure players can only move pieces of their own color
  def valid_move?(old_pos, new_pos)
    p @board[old_pos[0].to_i][old_pos[1].to_i].available_moves
    @board[old_pos[0].to_i][old_pos[1].to_i]
      .available_moves.include?(
        [new_pos[0].to_i, new_pos[1].to_i]
      )
  end

  def make_move(old_pos, new_pos)
    move_piece(old_pos, new_pos)
    generator
  end

  def move_piece(old_pos, new_pos)
    p new_pos
    @board[new_pos[0].to_i][new_pos[1].to_i] = @board[old_pos[0].to_i][old_pos[1].to_i]
    @board[new_pos[0].to_i][new_pos[1].to_i].position = [new_pos[0].to_i, new_pos[1].to_i]
    @board[old_pos[0].to_i][old_pos[1].to_i] = '-'
  end

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
    @board[1][0] = Pawn.new([1, 0], 'B')
    @board[1][1] = Pawn.new([1, 1], 'B')
    @board[1][2] = Pawn.new([1, 2], 'B')
    @board[1][3] = Pawn.new([1, 3], 'B')
    @board[1][4] = Pawn.new([1, 4], 'B')
    @board[1][5] = Pawn.new([1, 5], 'B')
    @board[1][6] = Pawn.new([1, 6], 'B')
    @board[1][7] = Pawn.new([1, 7], 'B')
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
