require_relative '../src/digit'
require_relative '../lib/numbers'

describe Digit do
  it 'finds numbers that are one move away from a well formed number' do
    one =
        "   " +
        "  |" +
        "  |" +
        "   "
    digit = Digit.new(one)
    expect(digit.one_move_away).to eql([7])
  end

  it 'finds numbers that are one move away from a malformed number' do
    malformed =
        " _ " +
        "|  " +
        "|_|" +
        "   "
    digit = Digit.new(malformed)
    expect(digit.one_move_away).to eql([0,6])
  end
end