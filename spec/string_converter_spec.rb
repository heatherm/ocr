require_relative '../src/string_converter'
require_relative '../lib/numbers'

describe StringConverter do
  let(:account_numbers) {
    [
        [
            "xxxxxxxxxxxxxxxxxxxxxxxxxxx\n",
            "  |  |  |  |  |  |  |  |  |\n",
            "  |  |  |  |  |  |  |  |  |\n",
            "xxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
        ],
        [
            " _  _  _  _  _  _  _  _  _x\n",
            "  |  |  |  |  |  |  |  |  |\n",
            "  |  |  |  |  |  |  |  |  |\n",
            "xxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
        ]
    ]
  }

  let(:transposed_accounts) {
    [
        [
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            ["x", " ", " ", "x"],
            ["x", " ", " ", "x"],
            ["x", "|", "|", "x"],
            []
        ], [
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            [" ", "|", "|", "x"],
            [" ", " ", " ", "x"],
            ["_", " ", " ", "x"],
            ["x", "|", "|", "x"],
            []]
    ]
  }

  let(:accounts_as_number_strings){
    [
        [
            "   "+
            "  |"+
            "  |"+
            "   ", "     |  |   ", "     |  |   ", "     |  |   ", "     |  |   ", "     |  |   ", "     |  |   ", "     |  |   ", "     |  |   ", ""],
        [" _   |  |   ", " _   |  |   ", " _   |  |   ", " _   |  |   ", " _   |  |   ", " _   |  |   ", " _   |  |   ", " _   |  |   ", " _   |  |   ", ""]
    ]
  }

  context 'valid_checksum?' do
    let(:possibilties) { Possibilities.new([]) }

    it 'validates good account numbers' do
      expect(possibilties.valid_checksum?('345882865')).to be
    end

    it 'invalidates bad account numbers' do
      expect(possibilties.valid_checksum?('555555555')).not_to be
    end
  end

  context 'when multiple matches are found as alternatives for a non-number' do
    context 'when it can find a number one move away' do
      it 'uses that number instead' do
        accounts = [
            [
                " _     _  _  _  _  _  _    ",
                "| || || || || || || ||_   |",
                "|_||_||_||_||_||_||_| _|  |",
                "                           "
            ]
        ]
        StringConverter.new(accounts).convert.should == ['000000051']
      end
    end

    context 'when it can find many numbers one move away' do
      it 'uses the one that passes checksum' do
        accounts = [
            [
                "    _  _  _  _  _  _     _ ",
                "|_||_|| ||_||_   |  |  | _ ",
                "  | _||_||_||_|  |  |  | _|",
                "                           "
            ]
        ]
        StringConverter.new(accounts).convert.should == ['490867715']
      end
    end

  end

  context 'when a number does not pass checksum' do
    context 'when it can find an alternative' do
      it 'finds alternatives for numbers that do not pass checksum and appends' do
        accounts = [
            [
                " _  _  _  _  _  _  _  _  _ ",
                " _|| || || || || || || || |",
                "|_ |_||_||_||_||_||_||_||_|",
                "                           "
            ]
        ]
        StringConverter.new(accounts).convert.should == ['200800000']
      end

      context 'when there are multiple alternatives' do
        it 'finds all possibilities' do
          accounts = [
              [
                  " _  _  _  _  _  _  _  _  _ ",
                  "|_ |_ |_ |_ |_ |_ |_ |_ |_ ",
                  " _| _| _| _| _| _| _| _| _|",
                  "                           "
              ]
          ]
          actual = StringConverter.new(accounts).convert.first
          actual.should match(/555555555 AMB/)
          actual.should match(/555655555/)
          actual.should match(/559555555/)
        end
      end
    end

    context 'when it cannot find an alternative' do
      it 'finds alternatives for numbers that do not pass checksum and appends' do
        accounts = [
            [
                " _  _  _  _  _  _  _  _  _ ",
                " _|| || |  || || || || || |",
                "|_ |_||_|  ||_||_||_||_||_|",
                "                           "
            ]
        ]

        StringConverter.new(accounts).convert.should == ['200700000 ILL']
      end
    end
  end

end