# frozen_string_literal: true

class King < Piece
  attr_accessor :available_moves, :position, :color

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
    @last_move = false
  end

  def moveset
    [[1, 0],
     [1, 1],
     [0, 1],
     [-1, 1],
     [-1, 0],
     [-1, -1],
     [0, -1],
     [1, -1]]
  end
end
