# frozen_string_literal: true

class King < Piece
  attr_reader :position
  attr_accessor :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end

  def moveset
    [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
  end
end
