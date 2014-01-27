require_relative 'number_segment'

class HorizontalSection
  attr_reader :section

  def initialize(line)
    @section = []
    line.chars.each_slice(3) do |num_part|
      @section << NumberSegment.new(num_part).segment
    end
  end
end