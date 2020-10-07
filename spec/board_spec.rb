# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/translator'
require_relative '../lib/piece'
require_relative '../lib/node'
require_relative '../lib/pawn'
require_relative '../lib/rook'
require_relative '../lib/night'
require_relative '../lib/bishop'
require_relative '../lib/queen'
require_relative '../lib/king'

# rubocop:disable Metrics/BlockLength
# rubocop:disable Style/WordArray
describe Board do
  INITIAL_BOARD_STATE = [['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
                         ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
                         ['-', '-', '-', '-', '-', '-', '-', '-'],
                         ['-', '-', '-', '-', '-', '-', '-', '-'],
                         ['-', '-', '-', '-', '-', '-', '-', '-'],
                         ['-', '-', '-', '-', '-', '-', '-', '-'],
                         ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
                         ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']].freeze

  context 'before the game starts' do
    subject(:board) { described_class.new }
    # it 'creates the board correctly' do
    #   expect(board.board).to eq(INITIAL_BOARD_STATE)
    # end
  end
  context 'while the game is not over' do
    context 'when adding a move to the board' do
      subject(:board) { described_class.new }
      before do
        expect(board).to receive(:player_input).and_return('a2')
        expect(board).to receive(:player_input).and_return('a4')
        board.get_move('W')
      end
      context 'the move is valid' do
        it 'adds the move to the board' do
          board_array = board.instance_variable_get(:@board)
          tile = board_array[4][0]
          expect(tile.class.name).to eq('Pawn')
          expect(tile.color).to eq('W')
        end
        # it 'displays the board correctly after a move' do
        #   expect(board.to_s).to eq([['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
        #                             ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
        #                             ['-', '-', '-', '-', '-', '-', '-', '-'],
        #                             ['-', '-', '-', '-', '-', '-', '-', '-'],
        #                             ['P', '-', '-', '-', '-', '-', '-', '-'],
        #                             ['-', '-', '-', '-', '-', '-', '-', '-'],
        #                             ['-', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
        #                             ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']])
        #   board.to_s
        # end
      end
      context 'the move is invalid' do
        it 'does not add the move to the board' do
          expect(board).to receive(:player_input).and_return('h2').twice
          expect(board).to receive(:invalid_move)
          board.get_move('W')
          board_array = board.instance_variable_get(:@board)
          own_tile = board_array[6][7]
          target_tile1 = board_array[5][7]
          target_tile2 = board_array[4][7]
          expect(own_tile.class.name).to eq('Pawn')
          expect(target_tile1).to eq('-')
          expect(target_tile2).to eq('-')
        end
      end
    end
    # context 'when checking for a win' do
    #   subject(:board) { described_class.new }
    # end
  end
end
