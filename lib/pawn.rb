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

  # remember to not allow promotion if it puts the same color king at check
  # make sure everything related to pawn checking is tested (especially diagonal captures)
  def generate_available_moves(pos, parent, board, _danger_squares, nodes = [])
    return promotion(pos, board) if can_promote?(pos, board)

    moveset.each do |direction|
      blocked = false
      king = find_opponent_king(board, color)
      found_check = false
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
        if check?(new_column, new_row, board)
          # self.checker = true
          set_check(king)
          found_check = true
        end
        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
      end
      @attack_ray = direction if found_check
    end
    add_diagonal_captures(pos, board)

    nodes
  end

  def generate_available_moves_in_check(pos, parent, board, _danger_squares, nodes = [])
    return promotion(pos, board) if can_promote?(pos, board)

    p 'generating moves in check'
    # self.checker = false
    moveset.each do |direction|
      blocked = false
      king = find_opponent_king(board, color)
      found_check = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        if common_legality_checks(new_column, new_row, board) ||
           blocked_pawn?(new_column, new_row, board) ||
           blocked ||
           !can_block_check?(new_column, new_row, board)

          blocked = true
          next
        end

        @already_moved << [new_column, new_row]
        if check?(new_column, new_row, board)
          # self.checker = true
          set_check(king)
          found_check = true
        end
        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
      end
      @attack_ray = direction if found_check
    end
    add_diagonal_captures(pos, board)

    nodes
  end

  private

  def can_promote?(pos, board)
    tile = board[pos[0]][pos[1]]
    color = tile.color
    case color
    when 'W'
      tile.position[0] == 0
    when 'B'
      tile.position[0] == 7
    end
  end

  def promotion(pos, board, promotion_piece = Queen)
    color = board[pos[0]][pos[1]].color
    board[pos[0]][pos[1]] = promotion_piece.new(pos, color)
    # for Piece::#level_order
    []
  end

  def blocked_pawn?(new_column, new_row, board)
    board[new_column][new_row] != '-'
  end

  # pasta la vista
  # THIS NEEDS TO PREVENT KING MOVES DIAGONALLY or maybe in King's movegen
  def add_diagonal_captures(pos, board)
    DIAGONAL_CAPTURES_BLACK_PAWN.each do |move|
      king = find_opponent_king(board, 'B')
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]

      # not sure if it needs to be -1
      next if out_of_bounds?(new_row, new_column, 7, -1)

      tile = board[new_column][new_row]
      @available_moves << tile.position unless tile.nil? || tile == '-' || tile.color == color || color == 'W'
      next unless check?(new_column, new_row, board)

      # self.checker = true
      set_check(king)
      @attack_ray = move
    end

    DIAGONAL_CAPTURES_WHITE_PAWN.each do |move|
      king = find_opponent_king(board, 'W')
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]

      next if out_of_bounds?(new_row, new_column, 8, 0)

      tile = board[new_column][new_row]
      @available_moves << tile.position unless tile.nil? || tile == '-' || tile.color == color || color == 'B'
      next unless check?(new_column, new_row, board)

      # self.checker = true
      set_check(king)
      @attack_ray = move
    end
  end
end
