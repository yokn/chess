# frozen_string_literal: true

class Pawn < Piece
  attr_reader :position
  attr_accessor :available_moves

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
  end

  # only piece in the game that changes moveset depending on the player
  def moveset
    if @color == 'B'
      [[1, 0], [2, 0]]
    else
      [[-1, 0], [-2, 0]]
    end
  end
end
