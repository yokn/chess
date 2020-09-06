# frozen_string_literal: true

class Knight < Piece
  attr_reader :position
  attr_accessor :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end

  def moveset
    [[2, 1], [2, -1], [1, 2], [1, -2],
     [-2, -1], [-2, 1], [-1, -2], [-1, 2]]
  end
end
