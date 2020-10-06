# frozen_string_literal: true

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new('W')
    @player2 = Player.new('B')
  end

  def setup_game
    @current_player = @player1
    @board.set_pieces
    play_game
  end

  private

  def change_current_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play_game
    until game_over?
      @board.to_s
      announce_turn
      @board.get_move(@current_player.color)
      change_current_player
    end
  end

  def game_over?
    if @board.tie?
      puts "It's a tie!"
    elsif @board.checkmate?
      display_winner
    else
      false
    end
  end

  def display_winner
    puts "#{@current_player} won!"
  end
end

def announce_turn
  puts @current_player.color == 'W' ? "White's turn" : "Black's turn"
end
