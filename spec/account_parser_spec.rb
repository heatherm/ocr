require_relative '../src/account_parser'
require_relative '../lib/numbers'

describe AccountParser do
  it 'parses multiple account numbers' do
    expected = [[
    " _  _  _  _  _  _  _  _  _ \n",
    "| || || || || || || || || |\n",
    "|_||_||_||_||_||_||_||_||_|\n",
    "                           \n"]]

    expect(StringConverter).to receive(:new)
                               .with(expected)
                               .and_return(double.as_null_object)

    all_zeros =
        " _  _  _  _  _  _  _  _  _ \n"+
        "| || || || || || || || || |\n"+
        "|_||_||_||_||_||_||_||_||_|\n"+
        "                           \n"

    AccountParser.parse(StringIO.new(all_zeros))
  end
end