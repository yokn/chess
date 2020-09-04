# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'king'
require_relative 'queen'

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new('white')
    @player2 = Player.new('black')
  end

  def setup_game
    @current_player = @player2
    play_game
  end

  private

  def change_current_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play_game
    change_current_player
    @board.get_move
    @board.to_s
    game_over?
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
