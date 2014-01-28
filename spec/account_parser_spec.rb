require_relative '../src/account_parser'
require_relative '../lib/numbers'

describe AccountParser do
  include Numbers

  it 'parses multiple account numbers' do
    NumberMatrixConverter.any_instance.stub(:valid?).and_return(true)

    all_zeros = " _  _  _  _  _  _  _  _  _ \n"+
                "| || || || || || || || || |\n"+
                "|_||_||_||_||_||_||_||_||_|\n"+
                "                           \n"

    all_ones = "                           \n"+
               "  |  |  |  |  |  |  |  |  |\n"+
               "  |  |  |  |  |  |  |  |  |\n"+
               "                           \n"

    entry = AccountParser.parse(StringIO.new(all_zeros+all_ones))

    [0,1].each do |account_number|
      (0..8).step(1) do |n|
        actual = String(entry[account_number][n])
        expect(actual).to eql(account_number.to_s)
      end
    end
    
  end
end