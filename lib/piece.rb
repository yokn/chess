# frozen_string_literal: true

class Piece
  def initialize; end

  # refactor movesets
  # if last move type == push, can keep going
  # if last move type == capture, stops
  # add if slider check
  # vvvvvvvvvvvvvvvvvvvvvvvvvvv
  # SWITCH TO GENERATING RAYS FOR SLIDER PIECES (ONE FOR EACH DIRECTION)
  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  # PREVENT KNIGHT FROM EATING OWN PIECES and invalid moves
  # maybe move movegen logic unique to each class instead of having them all inherit it
  def generate_available_moves(pos, parent, board, nodes = [])
    moveset.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]
      next if
        out_of_bounds?(new_column, new_row) ||
        occupied_by_same_color?(new_column, new_row, board) ||
        @already_moved.include?([new_column, new_row])

      # determine_move_type(new_column, new_row, board, parent)
      # slidergen if @slider

      @already_moved << [new_column, new_row]
      nodes << Node.new([new_column, new_row], parent)
      p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
    end
    nodes
  end

  # change the knight into something correct and relevant
  # remove queue
  def level_order(pointer, board, _queue = [])
    @already_moved = []
    knight = Node.new(pointer)

    result = generate_available_moves(knight.data, knight, board)
    p result
    return if result.empty?

    until result.empty?
      knight = result.shift
      @available_moves << knight.data
    end
    @available_moves.uniq!
  end

  private

  def out_of_bounds?(new_column, new_row)
    if (new_column > 7) || new_column.negative? || ((new_row > 7) || new_row.negative?)
      p "oob for #{position} at #{[new_column, new_row]}"
      true
    else
      false
    end
  end

  def occupied_by_same_color?(new_column, new_row, board)
    return if board[new_column][new_row] == '-'

    if board[new_column][new_row].color == color
      p "same_color for #{position} at #{[new_column, new_row]}"
      true
    else
      false
    end
  end

  # this doesn't work
  # def same_tile?(new_column, new_row, board)
  #   board[new_column][new_row] == position
  # end

  # change this method's and the variable's names
  # def determine_move_type(new_column, new_row, board, parent)
  #   @last_move = if slider_changing_directions?(new_column, new_row, board, parent) ||
  #                   capture_move?(new_column, new_row, board)
  #                  true
  #                else
  #                  false
  #                end
  # end

  def capture_move?(new_column, new_row, board)
    p "capture_move for #{position} at #{[new_column, new_row]}"
    board[new_column][new_row] != '-'
  end
end
