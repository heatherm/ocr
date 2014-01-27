require_relative 'horizontal_section'

class RawAccountNumber
  attr_reader :rows

  def initialize(four_lines)
    @rows = []

    four_lines.each do |line|
      @rows << HorizontalSection.new(line).section
    end
  end

  def as_numbers
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
end