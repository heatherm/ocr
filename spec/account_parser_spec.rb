require_relative '../src/account_parser'
require_relative '../lib/numbers'

describe AccountParser do
  include Numbers

  it 'parses a single account number' do
    all_zeros = " _  _  _  _  _  _  _  _  _ \n| || || || || || || || || |\n|_||_||_||_||_||_||_||_||_|\n                           \n"
    entry = AccountParser.parse(all_zeros)
    (0..8).step(1) do |n|
      expect(entry[0][n]).to eql(Numbers::ZERO)
    end
  end

  it 'parses multiple account numbers' do
    all_zeros = " _  _  _  _  _  _  _  _  _ \n| || || || || || || || || |\n|_||_||_||_||_||_||_||_||_|\n                           \n"
    all_ones = "                           \n  |  |  |  |  |  |  |  |  |\n  |  |  |  |  |  |  |  |  |\n                           \n"
    entry = AccountParser.parse(all_zeros+all_ones)
    (0..8).step(1) do |n|
      expect(entry[1][n]).to eql(Numbers::ONE)
    end
  end
end