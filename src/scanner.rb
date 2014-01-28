require_relative 'account_parser'

class Scanner

  def initialize stdin
    puts AccountParser.parse(stdin)
  end

end