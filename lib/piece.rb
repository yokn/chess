# frozen_string_literal: true

class Piece
  attr_accessor :attack_ray, :checker
  def initialize
    @attack_ray = []
    @checker = false
  end

  # break this up to multiple methods
  # make sure kings can never move adjacent to the opposing king
  # make sure to write testS for this ^^^^^^^^^^^^^^^^^^^^^^^^^^
  # MOVE ALL CHECK CHECKING TO Board maybe
  # allow king to capture the checker to get out of check
  def generate_available_moves(pos, parent, board, _danger_squares, nodes = [])
    # self.checker = false
    moveset.each do |direction|
      blocked = false
      king = find_opponent_king(board, color)
      found_check = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        if common_legality_checks(new_column, new_row, board) || blocked
          blocked = true
          next
        end
        @already_moved << [new_column, new_row]

        if check?(new_column, new_row, board)
          # self.checker = true
          set_check(king)
          found_check = true
        end

        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
        blocked = true if capture_move?(new_column, new_row, board)
      end
      @attack_ray = direction if found_check
      # p @attack_ray
    end
    nodes
  end

  def generate_available_moves_in_check(pos, parent, board, _danger_squares, nodes = [])
    p 'generating moves in check'
    # self.checker = false
    moveset.each do |direction|
      blocked = false
      king = find_opponent_king(board, color)
      found_check = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        if common_legality_checks(new_column, new_row, board) || blocked || !can_block_check?(new_column, new_row, board)
          blocked = true
          next
        end
        @already_moved << [new_column, new_row]

        if check?(new_column, new_row, board)
          # self.checker = true
          set_check(king)
          found_check = true
        end

        nodes << Node.new([new_column, new_row], parent)
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
        blocked = true if capture_move?(new_column, new_row, board)
      end
      @attack_ray = direction if found_check
    end
    nodes
  end

  def can_block_check?(new_column, new_row, board, result = [])
    # p 'hereeee'
    board.each do |row|
      row.each do |tile|
        next if tile == '-'
        next unless tile.checker

        pos = []
        pos << tile.position[0]
        pos << tile.position[1]
        # check if can take the checker
        result << (pos == [new_column, new_row])
        # p tile.attack_ray
        tile.attack_ray.each do |move|
          testing_loc = [pos[0] + move[0], pos[1] + move[1]]
          # p testing_loc
          # check if can block the checker
          result << (testing_loc == [new_column, new_row])
        end
        # p result
        return result.include?(true)
      end
    end
  end

  # change the knight into something correct and relevant
  def level_order(board, danger_squares, check)
    @available_moves = []
    @already_moved = []
    knight = Node.new(position)

    # return if king_in_double_check?(board) && self.class.name != 'King'

    attacked_squares = generate_attacked_squares(knight.data, board)

    # king = find_own_king(board, color)
    result = if check
               generate_available_moves_in_check(knight.data, knight, board, danger_squares)
             else
               generate_available_moves(knight.data, knight, board, danger_squares)
             end

    # p result
    until result.empty?
      knight = result.shift
      @available_moves << knight.data
    end
    @available_moves.uniq!
    attacked_squares
  end

  # need to remove the opposing king from the board when checking this for slider x-rays
  # ^^^^^^^^^^^^^^
  def generate_attacked_squares(pos, board, tiles = [])
    moveset.each do |direction|
      blocked = false
      direction.each do |move|
        new_column = pos[0] + move[0]
        new_row = pos[1] + move[1]
        if out_of_bounds?(new_column, new_row) || blocked
          blocked = true
          next
        end

        tiles << [new_column, new_row]
        # p "[#{new_column},#{new_row}] is possible for #{self.class.name} at #{pos}"
        blocked = true if capture_move?(new_column, new_row, board)
      end
    end
    tiles
  end

  # needs to be called after every piece has received their available moves
  def find_checkers(board, color)
    @checkers = []
    king = find_opponent_king(board, color)
    board.each do |row|
      row.each do |tile|
        next if tile == '-'

        # tile.checker = false
        next unless tile.available_moves.include?(king.position)

        tile.checker = true
        @checkers << tile
      end
    end
    if @checkers.empty?
      p "resetting check of #{king.color} king"
      reset_check(king)
    end
    p "checkers: #{@checkers}"
    @checkers
  end

  def find_opponent_king(board, color)
    board.each do |row|
      row.each do |tile|
        next unless tile.class.name == 'King' && tile.color != color

        return tile
      end
    end
  end

  def find_own_king(board, color)
    board.each do |row|
      row.each do |tile|
        next unless tile.class.name == 'King' && tile.color == color

        return tile
      end
    end
  end

  private

  # should just count the number of checkers instead
  def king_in_double_check?(board)
    board.each do |row|
      row.each do |tile|
        next unless tile.class.name == 'King' && tile.color == color

        return tile.double_check
      end
    end
  end

  def reset_check(king)
    king.in_check = false
    king.double_check = false
  end

  def set_check(king)
    king.in_check ? king.double_check = true : king.in_check = true
  end

  def check?(new_column, new_row, board)
    tile = board[new_column][new_row]
    tile.class.name == 'King' && tile.color != color
  end

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
