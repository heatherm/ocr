require_relative '../lib/numbers'

class Digit

  def initialize(number)
    @distances = Numbers::STRING_TO_SCANNED.values.map { |v| levenshtein_distance(v, number) }
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