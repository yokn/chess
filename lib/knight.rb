# frozen_string_literal: true

class Knight < Piece
  attr_accessor :available_moves, :position, :color, :slider

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
    @slider = false
    @last_move = false
  end

  def moveset
    [[[2, 1]], [[2, -1]], [[1, 2]], [[1, -2]],
     [[-2, -1]], [[-2, 1]], [[-1, -2]], [[-1, 2]]]
  end
end
