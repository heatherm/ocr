class NumberSegment
  attr_reader :segment

  def initialize(num_part)
    @segment = []
    num_part.each do |x|
      case x
        when '_'
          @segment << 0
        when '|'
          @segment << 1
        else
          @segment << nil
      end
    end
  end
end