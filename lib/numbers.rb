module Numbers
  ZERO = [[3,0,3], [1,3,1], [1,0,1], [3,3,3]]
  ONE = [[3,3,3], [3,3,1], [3,3,1], [3,3,3]]
  TWO = [[3,0,3],[3,0,1],[1,0,3],[3,3,3]]
  THREE = [[3,0,3],[3,0,1],[3,0,1],[3,3,3]]
  FOUR = [[3,3,3],[1,0,1],[3,3,1],[3,3,3]]
  FIVE = [[3,0,3],[1,0,3],[3,0,1],[3,3,3]]
  SIX = [[3,0,3],[1,0,3],[1,0,1],[3,3,3]]
  SEVEN = [[3,0,3],[3,3,1],[3,3,1],[3,3,3]]
  EIGHT = [[3,0,3],[1,0,1],[1,0,1],[3,3,3]]
  NINE = [[3,0,3],[1,0,1],[3,0,1],[3,3,3]]

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

end