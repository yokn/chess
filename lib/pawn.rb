# frozen_string_literal: true

STARTING_POSITION_BLACK_PAWN = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze
STARTING_POSITION_WHITE_PAWN = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze

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
    p @position
    if @color == 'B'
      if STARTING_POSITION_BLACK_PAWN.include?(@position)
        [[[1, 0], [2, 0]]]
      else
        [[[1, 0]]]
      end
    else
      if STARTING_POSITION_WHITE_PAWN.include?(@position)
        [[[-1, 0], [-2, 0]]]
      else
        [[[-1, 0]]]
      end
    end
  end
end
