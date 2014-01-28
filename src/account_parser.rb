require_relative 'raw_account_number'
require_relative 'number_matrix_converter'
require_relative '../lib/numbers'

class AccountParser
  include Numbers

  def self.parse input
    all_entries = []
    input.readlines.delete_if{ |e| e == "\n" }.each_slice(4) do |four_lines|
      all_entries << RawAccountNumber.new(four_lines).as_numbers
    end
    NumberMatrixConverter.new(all_entries).convert
  end
end