# frozen_string_literal: true

class Piece
  def initialize; end

  # maybe make movegen logic unique to each class instead of having them all inherit it
  def generate_available_moves(pos, parent, board, nodes = [])
    moveset.each do |direction|
      blocked = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        if common_legality_checks(new_column, new_row, board) ||
           blocked
          blocked = true
          next
        end

        @already_moved << [new_column, new_row]
        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
        blocked = true if capture_move?(new_column, new_row, board)
      end
    end
    nodes
  end

  # change the knight into something correct and relevant
  def level_order(board)
    @available_moves = []
    @already_moved = []
    knight = Node.new(position)

    result = generate_available_moves(knight.data, knight, board)
    # p result

    until result.empty?
      knight = result.shift
      @available_moves << knight.data
    end
    @available_moves.uniq!
  end

  private

  def common_legality_checks(new_column, new_row, board)
    out_of_bounds?(new_column, new_row) ||
      occupied_by_same_color?(new_column, new_row, board) ||
      @already_moved.include?([new_column, new_row])
  end

  # not sure why pawns need different limits
  def out_of_bounds?(new_column, new_row, upper_limit = 7, lower_limit = 0)
    if (new_column > upper_limit) || new_column < lower_limit || ((new_row > upper_limit) || new_row < lower_limit)
      # p "oob for #{position} at #{[new_column, new_row]}"
      true
    else
      false
    end
  end

  def occupied_by_same_color?(new_column, new_row, board)
    return if board[new_column][new_row] == '-'

    # if board[new_column][new_row].color == color
    #    p "same_color for #{position} at #{[new_column, new_row]}"
    #   true
    # else
    #   false
    # end
    board[new_column][new_row].color == color
  end

  def capture_move?(new_column, new_row, board)
    # p "capture_move for #{position} at #{[new_column, new_row]}"
    board[new_column][new_row] != '-'
  end
end
