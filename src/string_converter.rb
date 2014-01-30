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

  private

  def find_best_match_for_strings
    account_numbers = []
    accounts_as_number_strings.each do |account|
      account_number_hash = create_number_hash(account)
      if many_matches
        account_numbers << choose_best_match(account_number_hash)
      else
        account_number = stringify_hash(account_number_hash)
        if account_number.match(/\?/)
          account_numbers << account_number + ' ILL'
        elsif valid_checksum?(account_number)
          account_numbers << account_number
        else
          find_similar_number(account_number, account_numbers)
        end
      end
    end
    account_numbers
  end

  def find_similar_number(account_number, account_numbers)
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
      account_numbers << account_number + " ILL"
    end
  end

  def choose_best_match(account_number)
    possibilities = []
    cartesian_product = account_number.values.inject(&:product).map(&:flatten)
    cartesian_product.each do |possible_account|
      account_string = possible_account.join
      possibilities << account_string if valid_checksum?(account_string)
    end

    account_string = stringify_hash(account_number)
    if possibilities.length == 1
      possibilities.first
    elsif possibilities.length > 1
      account_string + " AMB #{possibilities}"
    else
      account_string + " ILL"
    end
  end

  def stringify_hash(hash)
    hash.values.flatten.join.to_s
  end

  def create_number_hash(number_string)
    number_string.reject!(&:empty?)
    {}.tap do |account_number|
      number_string.each_with_index do |char, i|
        if matching_number = Numbers::SCANNED_TO_STRING[char]
          account_number[i] = [matching_number]
        else
          similar_digits = Digit.new(char).one_move_away
          unless similar_digits || char.empty?
            account_number[i] = %w('?')
          else
            if similar_digits.count > 1
              @many_matches = true
            end
            account_number[i] = similar_digits
          end
        end
      end
    end
  end

  def segment_by_numbers
    @accounts_as_number_strings = []
    transposed_accounts.each do |account|
      [].tap do |number_string|
        account.each_slice(3) do |slice|
          number_string << slice.transpose.map(&:join).join.gsub(/[^|_]/, " ")
        end
        accounts_as_number_strings << number_string
      end
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

end