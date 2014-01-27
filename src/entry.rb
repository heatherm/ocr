class Entry
  def self.parse input
    numbers = []
    input.split(/(\n)/).delete_if{ |e| e == "\n" }.each_slice(4) do |account_number|
      rows = []
      account_number.each do |line|
        row = []
        line.chars.each_slice(3) do |num_part|
          segment = []
          num_part.each do |x|
            case x
              when ' '
                segment << nil
              when '_'
                segment << 0
              when '|'
                segment << 1
            end
          end
          row << segment
        end
        rows << row
      end
      (0..8).step(1) do |j|
        number = []
        (0..rows.count-1).step(1) do |i|
          number << rows[i][j]
        end
        numbers << number
      end
    end
   numbers
  end
end