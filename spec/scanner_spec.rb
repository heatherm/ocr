require_relative '../src/scanner'
require_relative '../src/account_parser'

describe Scanner do
  it 'prints the results from the account parser' do
    expect(AccountParser).to receive(:parse)
    Scanner.new(StringIO.new)
  end
end