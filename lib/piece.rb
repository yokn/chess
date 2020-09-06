# frozen_string_literal: true

class Piece
  def initialize; end

  # needs "blocking" detection
  def generate_available_moves(pos, moveset)
    @available_moves = []
    moveset.each do |move|
      next unless pos[0] + move[0] <= 7 && pos[0] + move[0] >= 0 &&
                  pos[1] + move[1] <= 7 && pos[1] + move[1] >= 0 &&
                  @available_moves << [pos[0] + move[0], pos[1] + move[1]]
    end
  end
end
