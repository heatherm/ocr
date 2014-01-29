require_relative 'digit'
require_relative '../lib/numbers'

class StringConverter
  attr_reader :account_numbers,
              :transposed_accounts,
              :accounts_as_number_strings,
              :many_matches

  def initialize(account_numbers)
    @account_numbers = account_numbers
  end

  def convert
    transpose_accounts
    segment_by_numbers
    find_best_match_for_strings
  end

  def find_best_match_for_strings
    account_numbers = []
    accounts_as_number_strings.each do |account|
      account_number_hash = create_number_hash(account)

      if many_matches
        account_numbers << choose_best_match(account_number_hash)
      else
        account_number = account_number_hash.values.flatten.join.to_s
        if account_number.match(/\?/)
          account_numbers << account_number + ' ILL'
        elsif valid_checksum?(account_number)
          account_numbers << account_number
        else
          find_other_number_to_satisfy_checksum(account_number, account_numbers)
        end
      end
    end
    account_numbers
  end

  def find_other_number_to_satisfy_checksum(account_number, account_numbers)
    result = [].tap do |possibilities|
      account_number.chars.each_with_index do |num, position|
        Numbers::ALTERNATIVES_TRUTH_TABLE[num].each do |alternative|
          account_number_copy = account_number.dup
          account_number_copy[position] = alternative
          if valid_checksum?(account_number_copy)
            possibilities << account_number_copy
          end
        end
      end
    end

    if result.length == 1
      account_numbers << result.first
    elsif result.length > 1
      account_numbers << account_number + " AMB #{result}"
    else
      account_numbers << account_number + ' ILL'
    end
  end

  def choose_best_match(account_number)
    result = [].tap do |possibilities|
      cartesian_product = account_number.values.inject(&:product).map(&:flatten)
      cartesian_product.each do |possible_account|
        account_string = possible_account.join
        possibilities << account_string if valid_checksum?(account_string)
      end
    end

    if result.length == 1
      result.first
    elsif result.length > 1
      account_number.values.flatten + " AMB #{result}"
    else
      account_number.values.flatten + ' ILL'
    end
  end

  def create_number_hash(number_string)
    {}.tap do |account_number|
      number_string.each_with_index do |char, i|
        if matching_number = Numbers::SCANNED_TO_STRING[char]
          account_number[i] = [matching_number]
        else
          matches = Digit.new(char).best_matches
          if matches.length > 1
            @many_matches = true
            account_number[i] = matches
          elsif matches.length == 1
            account_number[i] = matches
          else
            account_number[i] = ['?'] unless char.empty?
          end
        end
      end
    end
  end

  def segment_by_numbers
    @accounts_as_number_strings = []
    transposed_accounts.each do |account|
      number_string = []
      account.each_slice(3) do |slice|
        number_string << slice.transpose.map(&:join).join.gsub(/[^|_]/, " ")
      end
      accounts_as_number_strings << number_string
    end
    accounts_as_number_strings
  end

  def transpose_accounts
    @transposed_accounts = []
    account_numbers.each do |string_arrays|
      transposed = string_arrays.map(&:chars).transpose
      without_newlines = transposed.map{|a| a.delete_if{|e| e == "\n"}}
      transposed_accounts << without_newlines
    end
    transposed_accounts
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

end