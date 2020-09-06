# frozen_string_literal: true

class Queen < Piece
  attr_reader :position
  attr_accessor :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end

  # bishop + rook
  def moveset
    [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],

     [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
     [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
     [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]]
  end
end
