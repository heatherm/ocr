require_relative '../src/scanner'
require_relative '../src/account_parser'

describe Scanner do
  it 'parses the file' do
    expect(AccountParser).to receive(:parse) {['11','22']}
    Scanner.new(StringIO.new)
  end

  it 'prints the results' do
    expect(File).to receive(:open).with('output.txt', 'w')
    Scanner.new(StringIO.new).output_results
  end
end