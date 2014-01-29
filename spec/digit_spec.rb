require_relative '../src/digit'
require_relative '../lib/numbers'

describe Digit do
  include Numbers

  it 'finds numbers that are one move away' do
        #"   " +
        #"  |" +
        #"  |" +
        #"   "
    digit = Digit.new([[3,3,3],[3,3,1],[3,3,1],[3,3,3]])
    expect(digit.best_matches).to eql([7])
  end

  it 'finds numbers that are one move away' do
        #" _ " +
        #"|  " +
        #"|_|" +
        #"   "
    digit = Digit.new([[3,0,3],[1,3,3],[1,0,1],[3,3,3]])
    expect(digit.best_matches).to eql([0,6])
  end
end