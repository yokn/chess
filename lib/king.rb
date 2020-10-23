# frozen_string_literal: true

class King < Piece
  attr_accessor :available_moves, :position, :color, :slider, :in_check, :double_check

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
    @slider = false
    @last_move = false
    @in_check = false
    @double_check = false
  end

  def moveset
    [[[1, 0]],
     [[1, 1]],
     [[0, 1]],
     [[-1, 1]],
     [[-1, 0]],
     [[-1, -1]],
     [[0, -1]],
     [[1, -1]]]
  end

  def generate_available_moves(pos, parent, board, danger_squares, nodes = [])
    p 'generating moves -- KING'
    # p danger_squares
    moveset.each do |direction|
      blocked = false
      # king = find_opponent_king(board, color)
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        # p new_column
        # p new_row
        # print [new_column, new_row] if danger_squares.include?([new_column, new_row])
        if common_legality_checks(new_column, new_row, board) || blocked ||
           danger_squares.include?([new_column, new_row])
          blocked = true
          next
        end
        @already_moved << [new_column, new_row]

        # set_check(king) if check?(new_column, new_row, board)

        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
        blocked = true if capture_move?(new_column, new_row, board)
      end
    end
    nodes
  end

  def generate_available_moves_in_check(pos, parent, board, danger_squares, nodes = [])
    p 'generating moves in check -- KING'
    # p danger_squares
    moveset.each do |direction|
      blocked = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]

        # delete this if you do what's written above the #generator
        # checkers = find_checkers(board, color)
        # p checkers
        # checkers.each do |checker|
        #   p checker.position
        #   next unless checker.position == [new_column, new_row]

        #   @already_moved << [new_column, new_row]

        #   nodes << Node.new([new_column, new_row], parent)
        #   next
        # end

        if common_legality_checks(new_column, new_row, board) || blocked ||
           !can_block_check?(new_column, new_row, board) ||
           danger_squares.include?([new_column, new_row])
          blocked = true
          next
        end
        @already_moved << [new_column, new_row]

        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
        blocked = true if capture_move?(new_column, new_row, board)
      end
    end
    nodes
  end
end
