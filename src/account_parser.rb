require_relative 'number_matrix_converter'
require_relative '../lib/numbers'

class AccountParser
  def self.parse input
    all_entries = []
    input.readlines.delete_if{ |e| e == "\n" }.each_slice(4) do |four_lines|
      all_entries << foo(four_lines)
    end
    NumberMatrixConverter.new(all_entries).convert
  end

  def self.foo(four_lines)
    @rows = []

    four_lines.each do |line|
      @rows << bar(line)
    end

    numbers = []
    (0..8).step(1) do |j|
      number = []
      (0..@rows.count-1).step(1) do |i|
        number << @rows[i][j]
      end
      numbers << number
    end
    numbers
  end

  def self.bar(line)
    @section = []
    line.chars.each_slice(3) do |num_part|
      @section << baz(num_part)
    end
    @section
  end

  def self.baz(num_part)
    @segment = []
    num_part.each do |x|
      case x
        when '_'
          @segment << 0
        when '|'
          @segment << 1
        else
          @segment << 3
      end
    end
    @segment
  end

end