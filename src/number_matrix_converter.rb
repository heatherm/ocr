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
      account_number = {}
      @has_matches = false
      account_number_matrix.each_with_index do |number, i|
        if number.eql?(Numbers::ZERO)
          account_number[i] =['0']
        elsif number.eql?(Numbers::ONE)
          account_number[i] =['1']
        elsif number.eql?(Numbers::TWO)
          account_number[i] =['2']
        elsif number.eql?(Numbers::THREE)
          account_number[i] =['3']
        elsif number.eql?(Numbers::FOUR)
          account_number[i] =['4']
        elsif number.eql?(Numbers::FIVE)
          account_number[i] =['5']
        elsif number.eql?(Numbers::SIX)
          account_number[i] =['6']
        elsif number.eql?(Numbers::SEVEN)
          account_number[i] =['7']
        elsif number.eql?(Numbers::EIGHT)
          account_number[i] =['8']
        elsif number.eql?(Numbers::NINE)
          account_number[i] =['9']
        else
          matches = Digit.new(number).best_matches
          if matches.length > 1
            @has_matches = true
            account_number[i] = matches
          elsif matches.length == 1
            account_number[i] = matches
          else
            account_number[i] = ['?']
          end
        end
      end
      if @has_matches
        possibilities = []
        cartesian_product = account_number.values.inject(&:product).map(&:flatten)
        cartesian_product.each do |possible_account|
          account_string = possible_account.join
          possibilities << account_string if valid_checksum?(account_string)
        end
        if possibilities.length == 1
          account_numbers << possibilities.first
        elsif possibilities.length > 1
          account_numbers << account_number + " AMB #{possibilities}"
        else
          account_numbers << account_number + ' ILL'
        end
      else
        account_number = account_number.values.flatten.join.to_s
        if account_number.match(/\?/)
          account_numbers << account_number + ' ILL'
        elsif valid_checksum?(account_number)
          account_numbers << account_number
        else
          number_possibilities = {
              '1' => ['7'],
              '2' => ['6'],
              '3' => ['9', '6'],
              '4' => [],
              '5' => ['6', '9'],
              '6' => ['8', '5'],
              '7' => ['1'],
              '8' => ['0', '6', '9'],
              '9' => ['8', '3', '5'],
              '0' => ['8']
          }
          possibilities = []
          account_number.chars.each_with_index do |num, position|
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
    end
    account_numbers
  end
end

class Digit
  STRING_TO_SCANNED = {
      "0" =>
          " _ " +
              "| |" +
              "|_|" +
              "   ",

      "1" =>
          "   " +
              "  |" +
              "  |" +
              "   ",

      "2" =>
          " _ " +
              " _|" +
              "|_ " +
              "   ",

      "3" =>
          " _ " +
              " _|" +
              " _|" +
              "   ",

      "4" =>
          "   " +
              "|_|" +
              "  |" +
              "   ",

      "5" =>
          " _ " +
              "|_ " +
              " _|" +
              "   ",

      "6" =>
          " _ " +
              "|_ " +
              "|_|" +
              "   ",

      "7" =>
          " _ " +
              "  |" +
              "  |" +
              "   ",

      "8" =>
          " _ " +
              "|_|" +
              "|_|" +
              "   ",

      "9" =>
          " _ " +
              "|_|" +
              " _|" +
              "   "
  }

  def initialize number
    string = ''
    number.each do |slice|
      slice.each do |num|
        case num
          when 0
            string += '_'
          when 1
            string += '|'
          else
            string += ' '
        end
      end
    end

    @distances = STRING_TO_SCANNED.values.map { |v| levenshtein_distance(v, string) }
  end

  def best_matches
    @distances.each_index.select { |i| @distances[i] == 1 }
  end

  def levenshtein_distance(s, t)
    m = s.length
    n = t.length
    return m if n == 0
    return n if m == 0
    d = Array.new(m+1) { Array.new(n+1) }

    (0..m).each { |i| d[i][0] = i }
    (0..n).each { |j| d[0][j] = j }
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if s[i-1] == t[j-1]
                    d[i-1][j-1]
                  else
                    [d[i-1][j]+1,
                     d[i][j-1]+1,
                     d[i-1][j-1]+1,
                    ].min
                  end
      end
    end
    d[m][n]
  end

end