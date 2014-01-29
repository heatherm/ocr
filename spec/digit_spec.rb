require_relative '../src/digit'
require_relative '../lib/numbers'

describe Digit do
  include Numbers

  it 'finds numbers that are one move away' do
    one =
        "   " +
        "  |" +
        "  |" +
        "   "
    digit = Digit.new(one)
    expect(digit.best_matches).to eql([7])
  end

  it 'finds numbers that are one move away' do
    malformed =
        " _ " +
        "|  " +
        "|_|" +
        "   "
    digit = Digit.new(malformed)
    expect(digit.best_matches).to eql([0,6])
  end
end