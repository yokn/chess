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
describe Board do
  INITIAL_BOARD_STATE = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R',
                         'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
                         '-', '-', '-', '-', '-', '-', '-', '-',
                         '-', '-', '-', '-', '-', '-', '-', '-',
                         '-', '-', '-', '-', '-', '-', '-', '-',
                         '-', '-', '-', '-', '-', '-', '-', '-',
                         'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
                         'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'].freeze

  context 'before the game starts' do
    subject(:board) { described_class.new }
    it 'creates the board correctly' do
      expect(board.to_s).to eq(INITIAL_BOARD_STATE)
    end
  end
  context 'while the game is not over' do
    context 'when adding a move to the board' do
      subject(:board) { described_class.new }
      before do
        expect(board).to receive(:player_input).and_return('a2')
        expect(board).to receive(:player_input).and_return('a3')
        board.get_move('W')
      end
      context 'the move is valid' do
        it 'adds the move to the board' do
          board_array = board.instance_variable_get(:@board)
          tile = board_array[5][0]
          expect(tile.class.name).to eq('Pawn')
          expect(tile.color).to eq('W')
        end
        it 'displays the board correctly after a move' do
          expect(board.to_s).to eq(['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R',
                                    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
                                    '-', '-', '-', '-', '-', '-', '-', '-',
                                    '-', '-', '-', '-', '-', '-', '-', '-',
                                    '-', '-', '-', '-', '-', '-', '-', '-',
                                    'P', '-', '-', '-', '-', '-', '-', '-',
                                    '-', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
                                    'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'])
        end
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
    context 'movement' do
      subject(:board) { described_class.new }
      it 'pawns can double move if they are at their starting positions' do
        expect(board).to receive(:player_input).and_return('a2')
        expect(board).to receive(:player_input).and_return('a4')
        board.get_move('W')
        board_array = board.instance_variable_get(:@board)
        tile = board_array[4][0]
        expect(tile.class.name).to eq('Pawn')
        expect(tile.color).to eq('W')
      end
      it 'pawns cannot double move if they are not at their starting positions' do
        # setup to move piece away from its starting position
        expect(board).to receive(:player_input).and_return('a2')
        expect(board).to receive(:player_input).and_return('a3')
        board.get_move('W')

        expect(board).to receive(:player_input).and_return('a3')
        expect(board).to receive(:player_input).and_return('a5')
        expect(board).to receive(:invalid_move)
        board.get_move('W')
        board_array = board.instance_variable_get(:@board)
        own_tile = board_array[5][0]
        target_tile = board_array[3][0]
        expect(own_tile.class.name).to eq('Pawn')
        expect(target_tile).to eq('-')
      end
      it 'pawns can be blocked' do
        # white and black pawns are against each other on the A file
        expect(board).to receive(:player_input).and_return('a2')
        expect(board).to receive(:player_input).and_return('a4')
        board.get_move('W')
        expect(board).to receive(:player_input).and_return('a7')
        expect(board).to receive(:player_input).and_return('a5')
        board.get_move('B')

        # white pawn cannot move forward because it is blocked
        expect(board).to receive(:player_input).and_return('a4')
        expect(board).to receive(:player_input).and_return('a5')
        expect(board).to receive(:invalid_move)
        board.get_move('W')
        # black pawn cannot move forward because it is blocked
        expect(board).to receive(:player_input).and_return('a5')
        expect(board).to receive(:player_input).and_return('a4')
        expect(board).to receive(:invalid_move)
        board.get_move('B')

        board_array = board.instance_variable_get(:@board)
        white_tile = board_array[4][0]
        black_tile = board_array[3][0]
        expect(white_tile.class.name).to eq('Pawn')
        expect(white_tile.color).to eq('W')
        expect(black_tile.class.name).to eq('Pawn')
        expect(black_tile.color).to eq('B')
      end
      it 'pawns can capture diagonally' do
        expect(board).to receive(:player_input).and_return('a2')
        expect(board).to receive(:player_input).and_return('a4')
        board.get_move('W')
        expect(board).to receive(:player_input).and_return('b7')
        expect(board).to receive(:player_input).and_return('b5')
        board.get_move('B')
        expect(board).to receive(:player_input).and_return('a4')
        expect(board).to receive(:player_input).and_return('b5')
        board.get_move('W')

        board_array = board.instance_variable_get(:@board)
        own_tile = board_array[4][0]
        target_tile = board_array[3][1]
        expect(target_tile.class.name).to eq('Pawn')
        expect(target_tile.color).to eq('W')
        expect(own_tile).to eq('-')
      end
    end
    # context 'when checking for a win' do
    #   subject(:board) { described_class.new }
    # end
  end
end
