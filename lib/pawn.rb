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
    if @color == 'B'
      STARTING_POSITION_BLACK_PAWN.include?(@position) ? [[[1, 0], [2, 0]]] : [[[1, 0]]]
    else
      STARTING_POSITION_WHITE_PAWN.include?(@position) ? [[[-1, 0], [-2, 0]]] : [[[-1, 0]]]
    end
  end

  def generate_available_moves(pos, parent, board, nodes = [])
    moveset.each do |direction|
      blocked = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        if common_legality_checks(new_column, new_row, board) ||
           blocked_pawn?(new_column, new_row, board) ||
           blocked

          blocked = true
          next
        end

        @already_moved << [new_column, new_row]
        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
      end
    end
    add_diagonal_captures(pos, board)
    nodes
  end

  private

  def blocked_pawn?(new_column, new_row, board)
    board[new_column][new_row] != '-'
  end

  # pasta la vista
  def add_diagonal_captures(pos, board)
    DIAGONAL_CAPTURES_BLACK_PAWN.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]

      # not sure if it needs to be -1
      next if out_of_bounds?(new_row, new_column, 7, -1)

      tile = board[new_column][new_row]
      @available_moves << tile.position unless tile.nil? || tile == '-' || tile.color == color || color == 'W'
    end

    DIAGONAL_CAPTURES_WHITE_PAWN.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]

      next if out_of_bounds?(new_row, new_column, 8, 0)

      tile = board[new_column][new_row]
      @available_moves << tile.position unless tile.nil? || tile == '-' || tile.color == color || color == 'B'
    end
  end
end
