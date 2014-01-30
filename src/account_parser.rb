require_relative 'string_converter'
require_relative '../lib/numbers'

class AccountParser
  def self.parse(input)
    parsed_entries = []
    input.readlines.delete_if{ |e| e == "\n" }.each_slice(4) do |four_lines|
      parsed_entries << four_lines
    end
    StringConverter.new(parsed_entries).convert
  end
end