require_relative 'account_parser'

class Scanner

  def initialize(stdin)
    @parsed = AccountParser.parse(stdin)
  end

  def output_results
    File.open('output.txt', 'w') do |file|
      @parsed.each do |account_number|
        file.write(account_number)
        file.write("\n")
      end
    end
  end

end