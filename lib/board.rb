# frozen_string_literal: true

class Board
  attr_reader :board
  def initialize
    @board = Array.new(8) { Array.new(8, '-') }
    @dummy_piece = Piece.new
    @white_attacked_squares = []
    @black_attacked_squares = []
    set_pieces
    generator
  end

  def set_pieces
    set_black_backrow
    set_black_pawns
    set_white_pawns
    set_white_backrow
  end

  def get_move(color, old_pos = [], new_pos = [])
    p 'Please enter the location of the piece you wish to move in algebraic notation'
    old_pos += Translator.to_matrix(player_input)
    return invalid_move(color) if empty_tile?(old_pos)
    return wrong_player(color) if wrong_player?(old_pos, color)

    display_available_moves(old_pos)

    p 'Please enter the location you wish to move to in algebraic notation'
    new_pos += Translator.to_matrix(player_input)
    valid_move?(old_pos, new_pos) ? make_move(old_pos, new_pos) : invalid_move(color)
  end

  def tie?; end

  def checkmate?; end

  # def to_s
  #   @board.each do |row|
  #     row.each do |tile|
  #       print tile == '-' ? '-' : tile.class.name[0]
  #       print ' '
  #     end
  #     puts ''
  #   end
  # end

  def to_s(board = @board, result = [])
    board.each do |row|
      row.each do |tile|
        puts "#{tile.color} #{tile.class.name} is in check!" if tile.class.name == 'King' && tile.in_check
        result << (tile == '-' ? '-' : tile.class.name[0])
      end
    end
    print_board(result)
  end

  private

  # helper of to_s
  def print_board(result)
    result.each_with_index do |tile, index|
      puts '' if (index % 8).zero? && index != 0
      print tile
      print ' '
      puts '' if (index % 63).zero? && index != 0
    end
  end

  def wrong_player?(old_pos, color)
    @board[old_pos[0].to_i][old_pos[1].to_i].color != color
  end

  def wrong_player(color)
    p "That's not your piece!"
    get_move(color)
  end

  def empty_tile?(old_pos)
    @board[old_pos[0].to_i][old_pos[1].to_i] == '-'
  end

  def invalid_move(color)
    p 'Invalid move. Try again.'
    get_move(color)
  end

  def display_available_moves(old_pos)
    puts 'Available moves:'
    @board[old_pos[0].to_i][old_pos[1].to_i].available_moves.each do |move|
      print Translator.to_algebraic(move) + ' '
    end
    puts ''
  end

  # need to generate the moves for the kings last--but what about the order of the kings themselves?

  def generator
    # incredibly bad hack
    2.times do
      # @dummy_piece.find_checkers(board, 'W')
      # @dummy_piece.find_checkers(board, 'B')
      white_king_check = @dummy_piece.find_own_king(board, 'W').in_check
      black_king_check = @dummy_piece.find_own_king(board, 'B').in_check

      # white_checkers[0].level_order unless white_checkers.empty?
      # black_checkers[0].level_order unless black_checkers.empty?

      @board.each do |row|
        row.each do |tile|
          next if tile == '-'
          next unless tile.checker

          p "working on CHECKER: #{tile.color} #{tile.class.name}"
          if tile.color == 'W'

            @white_attacked_squares += tile.level_order(@board, @black_attacked_squares, white_king_check)
          else

            # this returns nil somehow if you move a piece you are not legally allowed to move while your king is in check
            @black_attacked_squares += tile.level_order(@board, @white_attacked_squares, black_king_check)
          end
        end
      end

      @board.each_with_index do |row, index|
        row.each_with_index do |tile, inner_index|
          next if tile == '-'

          p "working on piece: #{tile.color} #{tile.class.name}"
          if tile.color == 'W'
            if tile.class.name == 'King'
              @white_king = tile
              next
            end
            @white_attacked_squares += tile.level_order(@board, @black_attacked_squares, white_king_check)
          else
            if tile.class.name == 'King'
              @black_king = tile
              next
            end
            # this returns nil somehow if you move a piece you are not legally allowed to move while your king is in check
            @black_attacked_squares += tile.level_order(@board, @white_attacked_squares, black_king_check)
          end

          # make sure kings' moves get generated after every other piece on the board
          next unless (index == 7) && (inner_index > 6)

          # does the order matter?
          @white_attacked_squares += @white_king.level_order(@board, @black_attacked_squares, white_king_check)
          @black_attacked_squares += @black_king.level_order(@board, @white_attacked_squares, black_king_check)
        end
      end
      remove_checker_pos_from_danger_squares_unless_supported(@white_attacked_squares, 'W')
      remove_checker_pos_from_danger_squares_unless_supported(@black_attacked_squares, 'B')
      @dummy_piece.find_checkers(board, 'W')
      @dummy_piece.find_checkers(board, 'B')
    end
  end

  # removes the checker's own position from danger squares
  # unless any piece of the checker's color's available moves include checkers posititon
  # this should solve 2 different problems:
  # king not being able to capture the checker to get out of check
  # and king being able capture the checker to get out of check even if there is a piece supporting the checker
  def remove_checker_pos_from_danger_squares_unless_supported(attacked_squares, color)
    @checker = nil
    @board.each do |row|
      row.each do |tile|
        next if tile == '-'
        next unless tile.checker && tile.color == color

        @checker = tile
      end
    end

    return if @checker.nil?

    @board.each do |row|
      row.each do |tile|
        next if tile == '-'
        next unless tile.color == color
        next unless tile.available_moves.include?(@checker.position)

        p "found a supporter: #{tile.color} #{tile.class.name} at #{tile.position}"
        return
      end
    end
    attacked_squares.delete(@checker.position)
  end

  def valid_move?(old_pos, new_pos)
    # p @board[old_pos[0].to_i][old_pos[1].to_i].available_moves
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
    @board[new_pos[0].to_i][new_pos[1].to_i] = @board[old_pos[0].to_i][old_pos[1].to_i]
    @board[new_pos[0].to_i][new_pos[1].to_i].position = [new_pos[0].to_i, new_pos[1].to_i]
    @board[old_pos[0].to_i][old_pos[1].to_i] = '-'
  end

  def player_input
    input = gets.chomp
    until input.match(/^[a-h][1-8]$/i)
      puts 'Invalid input. Make sure you are using algebraic notation e.g.: a2'
      input = gets.chomp
    end
    input
  end

  def set_black_backrow
    @board[0][0] = Rook.new([0, 0], 'B')
    @board[0][1] = Night.new([0, 1], 'B')
    @board[0][2] = Bishop.new([0, 2], 'B')
    @board[0][3] = Queen.new([0, 3], 'B')
    @board[0][4] = King.new([0, 4], 'B')
    @board[0][5] = Bishop.new([0, 5], 'B')
    @board[0][6] = Night.new([0, 6], 'B')
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
    @board[7][1] = Night.new([7, 1], 'W')
    @board[7][2] = Bishop.new([7, 2], 'W')
    @board[7][3] = Queen.new([7, 3], 'W')
    @board[7][4] = King.new([7, 4], 'W')
    @board[7][5] = Bishop.new([7, 5], 'W')
    @board[7][6] = Night.new([7, 6], 'W')
    @board[7][7] = Rook.new([7, 7], 'W')
  end
end
