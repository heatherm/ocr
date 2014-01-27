require_relative '../src/entry'
require_relative '../src/numbers'

describe Entry do
  include Numbers

  it 'parses input' do
    entry = Entry.parse(" _  _  _  _  _  _  _  _  _ \n| || || || || || || || || |\n|_||_||_||_||_||_||_||_||_|\n                           \n")
    (0..8).step(1) do |n|
      expect(entry[0]).to eql(Numbers::ZERO)
    end
  end
end