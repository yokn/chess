# frozen_string_literal: true

class Piece
  def initialize; end

  # refactor to bfs w/ parents
  # refactor movesets into smallest parts
  # if last move type == push, can keep going
  # if last move type == capture, stops
  # add if slider check
  def generate_available_moves(pos, parent, board, nodes = [])
    moveset.each do |move|
      new_column = pos[0] + move[0]
      new_row = pos[1] + move[1]
      next if
        out_of_bounds?(new_column, new_row) ||
        occupied_by_same_color?(new_column, new_row, board) ||
        same_tile?(new_column, new_row, board) ||
        @already_moved.include?([new_column, new_row])

      determine_move_type(new_column, new_row, board)

      # if @last_move

      @already_moved << [new_column, new_row]
      nodes << Node.new([new_column, new_row], parent)
      p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
      p @last_move
    end
    nodes
  end

  # change the knight into something correct and relevant
  def level_order(pointer, board, _finish = nil, queue = [])
    @already_moved = []

    knight = Node.new(pointer)
    queue << knight
    until queue.empty?
      # p queue
      p knight.data
      knight = queue.shift
      # p knight.data
      @available_moves << knight.data unless @last_move # not sure about this one

      # return if knight.data == finish

      result = generate_available_moves(knight.data, knight, board)
      queue += result unless result.nil? || @last_move # not sure about this one
    end
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
  def same_tile?(new_column, new_row, board)
    board[new_column][new_row] == position
  end

  # change this method's and the variable's names
  def determine_move_type(new_column, new_row, board)
    @last_move = board[new_column][new_row] != '-'
  end
end
