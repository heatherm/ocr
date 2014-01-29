require_relative '../src/account_parser'
require_relative '../lib/numbers'

describe AccountParser do
  include Numbers

  it 'parses multiple account numbers' do
    StringConverter.any_instance.stub(:valid?).and_return(true)

    all_zeros =
        " _  _  _  _  _  _  _  _  _ \n"+
        "| || || || || || || || || |\n"+
        "|_||_||_||_||_||_||_||_||_|\n"+
        "                           \n"

    entry = AccountParser.parse(StringIO.new(all_zeros))

    (0..8).step(1) do |n|
      actual = String(entry[0][n])
      expect(actual).to eql('0')
    end

  end
end