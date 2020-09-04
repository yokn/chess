# frozen_string_literal: true

# INITIAL PLAN:
# Create the Board
# Create two players of white and black colors
# Populate the board with both players' pieces
# While the game is not over:
#   Ask the current player for a move until they give a valid move
#   Carry out the move
#   Display the updated board
#   check for a check or mate

# Make it so you can save the board at any time (remember how to serialize?)
require_relative 'game'

Game.new.setup_game
