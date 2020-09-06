# frozen_string_literal: true

class Bishop < Piece
  attr_reader :position
  attr_accessor :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end

  def moveset
    [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7]]
  end
end
