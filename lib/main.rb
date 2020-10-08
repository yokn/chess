# frozen_string_literal: true

# INITIAL PLAN:
# Create the Board
# Create two players of white and black colors
# Populate the board with both players' pieces
# Generate the available moves for each piece
# While the game is not over:
#   Ask the current player for a move until they give a valid move
#   Carry out the move
#   Update each piece's available_moves
#   Display the updated board
#   check for a check or mate
# Display the game result

# Make it so you can save the board at any time (remember how to serialize?)
# Add special moves: En passant, castling, promotion
# Add basic ai
# Make tests not print anything to the console

require_relative 'game'
require_relative 'board'
require_relative 'player'
require_relative 'piece'
require_relative 'node'
require_relative 'translator'
require_relative 'pawn'
require_relative 'rook'
require_relative 'night'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

Game.new.setup_game
