# frozen_string_literal: true

class Pawn < Piece
  attr_accessor :available_moves, :position, :color, :slider

  def initialize(position, color)
    @position = position
    @color = color
    @available_moves = []
    @slider = false
    @last_move = false
  end

  # only piece in the game that changes moveset depending on the player
  # need to add diagonal capture
  # fix the position check for double moves
  def moveset
    if @color == 'B'

      [[[1, 0]]]

    else
      [[[-1, 0]]]

    end
  end
end
