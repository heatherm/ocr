require_relative 'raw_account_number'

class AccountParser
  def self.parse input
    all_entries = []
    input.readlines.delete_if{ |e| e == "\n" }.each_slice(4) do |four_lines|
      all_entries << RawAccountNumber.new(four_lines).as_numbers
    end
    all_entries
  end
end