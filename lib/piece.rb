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

      determine_move_type(new_column, new_row, board, parent)
      # if @last_move

      @already_moved << [new_column, new_row]
      nodes << Node.new([new_column, new_row], parent)
      p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
      p "last_move: #{@last_move}"
    end
    nodes
  end

  # change the knight into something correct and relevant
  def level_order(pointer, board, queue = [])
    @already_moved = []

    knight = Node.new(pointer)
    queue << knight
    until queue.empty?
      # p queue
      p knight.data
      knight = queue.shift
      # p knight.data

      # call a uniq! on this somewhere before it's presented to the player
      @available_moves << knight.data unless @last_move # not sure about this one

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
  def determine_move_type(new_column, new_row, board, parent)
    @last_move = slider_changing_directions?(new_column, new_row, board, parent) ||
                 capture_move?(new_column, new_row, board)
  end

  def slider_changing_directions?(new_column, new_row, _board, parent)
    return unless @slider

    p "slider_changing_directions for #{position} at #{[new_column, new_row]}"
    !((parent.data[0] == position[0]) || (parent.data[1] == position[1]))
  end
  #   gen_column
  #   gen_row

  #   (@possibilities_column&.include?(parent.data[0]) ||
  #   @possibilities_row&.include?(parent.data[1]))
  # end

  # def gen_column(possibilities_column = [])
  #   moveset.each do |x|
  #     possibilities_column << x[0]
  #   end
  #   @possibilities_column
  # end

  # def gen_row(possibilities_row = [])
  #   moveset.each do |x|
  #     possibilities_row << x[1]
  #   end
  #   @possibilities_row
  # end

  def capture_move?(new_column, new_row, board)
    p "capture_move for #{position} at #{[new_column, new_row]}"
    board[new_column][new_row] != '-'
  end
end
