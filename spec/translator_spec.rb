# frozen_string_literal: true

require_relative '../lib/translator'

describe Translator do
  subject(:translator) { described_class }
  it 'translates from matrix to algebraic notation correctly' do
    pos = [0, 0]
    expect(translator.to_algebraic(pos)).to eq('a8')
    pos = [7, 7]
    expect(translator.to_algebraic(pos)).to eq('h1')
  end
  context 'when translating from algebraic notation to matrix' do
    it 'translates correctly when the input is lowercase' do
      pos = 'a8'
      expect(translator.to_matrix(pos)).to eq([0, 0])
      pos = 'h1'
      expect(translator.to_matrix(pos)).to eq([7, 7])
    end
    it 'translates correctly when the input is UPPERCASE' do
      pos = 'E4'
      expect(translator.to_matrix(pos)).to eq([4, 4])
      pos = 'H7'
      expect(translator.to_matrix(pos)).to eq([1, 7])
    end
  end
end
