# frozen_string_literal: true

STARTING_POSITION_BLACK_PAWN = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze
STARTING_POSITION_WHITE_PAWN = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze
DIAGONAL_CAPTURES_BLACK_PAWN = [[1, 1], [1, -1]].freeze
DIAGONAL_CAPTURES_WHITE_PAWN = [[-1, -1], [-1, 1]].freeze

class Pawn < Piece
  attr_accessor :available_moves, :position, :color, :slider

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
    @slider = false
    @last_move = false
  end

  # only piece in the game that changes moveset depending on the player
  def moveset
    p @position
    if @color == 'B'
      if STARTING_POSITION_BLACK_PAWN.include?(@position)
        [[1, 0], [2, 0]]
      else
        [[1, 0]]
      end
    else
      if STARTING_POSITION_WHITE_PAWN.include?(@position)
        [[-1, 0], [-2, 0]]
      else
        [[-1, 0]]
      end
    end
  end

  def generate_available_moves(pos, parent, board, nodes = [])
    moveset.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]
      if  out_of_bounds?(new_column, new_row) ||
          occupied_by_same_color?(new_column, new_row, board) ||
          @already_moved.include?([new_column, new_row]) ||
          blocked_pawn?(new_column, new_row, board)
        next
      end

      @already_moved << [new_column, new_row]
      nodes << Node.new([new_column, new_row], parent)
      # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
    end
    add_diagonal_captures(pos, board)
    nodes
  end

  def blocked_pawn?(new_column, new_row, board)
    board[new_column][new_row] != '-'
  end

  # pasta la vista
  def add_diagonal_captures(pos, board, target_tile_black = [], target_tile_white = [])
    upper_limit = 8
    lower_limit = 0
    DIAGONAL_CAPTURES_BLACK_PAWN.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]
      next if new_row > upper_limit || new_row < lower_limit || new_column > upper_limit || new_column < lower_limit

      target_tile_black << board[new_column][new_row]
    end

    DIAGONAL_CAPTURES_WHITE_PAWN.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]
      next if new_row > upper_limit || new_row < lower_limit || new_column > upper_limit || new_column < lower_limit

      target_tile_white << board[new_column][new_row]
    end
    if color == 'B'
      target_tile_black.each do |tile|
        next if tile.nil? || tile == '-' || tile.color == color

        @available_moves << tile.position
      end
    else
      target_tile_white.each do |tile|
        next if tile.nil? || tile == '-' || tile.color == color

        @available_moves << tile.position
      end
    end
  end
end
