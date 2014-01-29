class NumberMatrixConverter
  def initialize number_matrices
    @number_matrices = number_matrices
  end

  def valid_checksum?(account_number)
    i = 2
    numbers = []
    numbers_for_checksum = account_number.chars.map(&:to_i).reverse
    first = numbers_for_checksum.shift
    numbers_for_checksum.each do |num|
      numbers << num * i
      i += 1
    end
    numbers.unshift(first).inject(:+) % 11 == 0
  end

  def convert
    account_numbers = []
    @number_matrices.each do |account_number_matrix|
      account_number = ''

      account_number_matrix.each do |number|
        if number.eql?(Numbers::ZERO)
          account_number +='0'
        elsif number.eql?(Numbers::ONE)
          account_number +='1'
        elsif number.eql?(Numbers::TWO)
          account_number +='2'
        elsif number.eql?(Numbers::THREE)
          account_number +='3'
        elsif number.eql?(Numbers::FOUR)
          account_number +='4'
        elsif number.eql?(Numbers::FIVE)
          account_number +='5'
        elsif number.eql?(Numbers::SIX)
          account_number +='6'
        elsif number.eql?(Numbers::SEVEN)
          account_number +='7'
        elsif number.eql?(Numbers::EIGHT)
          account_number +='8'
        elsif number.eql?(Numbers::NINE)
          account_number +='9'
        else
          account_number +='?'
        end
      end
       if account_number.match(/\?/)
         account_numbers << account_number + ' ILL'
       elsif valid_checksum?(account_number)
         account_numbers << account_number
       else
         number_possibilities = {
             '1' => ['7'],
             '2' => ['6'],
             '3' => ['9','6'],
             '4' => [],
             '5' => ['6','9'],
             '6' => ['8','5'],
             '7' => ['1'],
             '8' => ['0','6','9'],
             '9' => ['8','3','5'],
             '0' => ['8']
         }
         possibilities = []
         account_number.chars.each_with_index do |num,position|
           number_possibilities[num].each do |alternative|
             account_number_copy = account_number.dup
             account_number_copy[position] = alternative
             if valid_checksum?(account_number_copy)
               possibilities << account_number_copy
             end
           end
         end
         if possibilities.length == 1
           account_numbers << possibilities.first
         elsif possibilities.length > 1
           account_numbers << account_number + " AMB #{possibilities}"
         else
           account_numbers << account_number + ' ILL'
         end
       end
    end
    account_numbers
  end
end