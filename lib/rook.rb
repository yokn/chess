# frozen_string_literal: true

class Rook < Piece
  attr_reader :position
  attr_accessor :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end

  def moveset
    [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
     [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
     [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]]
  end
end
