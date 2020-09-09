# frozen_string_literal: true

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new('white')
    @player2 = Player.new('black')
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
    @board.to_s
    @board.get_move
    game_over?
    change_current_player
  end

  def game_over?
    if @board.tie?
      puts "It's a tie!"
    elsif @board.checkmate?
      display_winner
    else
      play_game
    end
  end

  def display_winner
    puts "#{@current_player} won!"
  end
end
