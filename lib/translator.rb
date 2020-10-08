# frozen_string_literal: true

ALGEBRAIC_COLUMN = 'abcdefgh'
ALGEBRAIC_ROW = '12345678'

# Translates between algebraic notation and the internal representation of the board(2d array)
module Translator
  def self.to_algebraic(pos)
    column = ALGEBRAIC_COLUMN[pos[1]]
    row = ALGEBRAIC_ROW.reverse[pos[0]]
    column + row
  end

  def self.to_matrix(pos)
    pos = pos.downcase
    column = ALGEBRAIC_COLUMN.index(pos[0])
    row = ALGEBRAIC_ROW.reverse.index(pos[1])
    [row, column]
  end
end
