require_relative '../src/scanner'
require_relative '../src/account_parser'

describe Scanner do
  it 'prints the results from the account parser to a file' do
    expect(AccountParser).to receive(:parse) {['11','22']}
    expect(File).to receive(:open).with('output.txt', 'w')
    Scanner.new(StringIO.new)
  end
end