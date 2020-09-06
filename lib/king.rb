# frozen_string_literal: true

class King < Piece
  attr_reader :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end
end
