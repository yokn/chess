# frozen_string_literal: true

class Bishop < Piece
  attr_accessor :available_moves, :position, :color, :slider

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
    @slider = true
    @last_move = false
  end

  def moveset
    [[1, 1],
     [1, -1],
     [-1, 1],
     [-1, -1]]
  end
end
