require_relative 'string_converter'
require_relative '../lib/numbers'

class AccountParser
  def self.parse input
    all_entries = []
    input.readlines.delete_if{ |e| e == "\n" }.each_slice(4) do |four_lines|
      all_entries << four_lines
    end
    StringConverter.new(all_entries).convert
  end

end