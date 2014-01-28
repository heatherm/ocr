class NumberMatrixConverter
  def initialize number_matrices
    @number_matrices = number_matrices
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
       if valid? account_number
         account_numbers << account_number
       elsif account_number.match(/\?/)
         account_numbers << account_number + ' ILL'
       else
         account_numbers << account_number + ' ERR'
       end
    end
    account_numbers
  end

  def valid?(account_number)
    i = 1
    numbers = []
    account_number.chars.map(&:to_i).reverse.each do |number|
      number += i
      numbers << number
      i+=1
    end
    numbers.inject(:*) % 11 == 0
  end
end