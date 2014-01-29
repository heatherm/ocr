require_relative '../src/number_matrix_converter'
require_relative '../lib/numbers'

describe NumberMatrixConverter do
  include Numbers

  context '#convert' do
    it 'converts a matrix to an account number' do
      NumberMatrixConverter.any_instance.stub(:valid_checksum?).and_return(true)
      matrix = [
          [
              Numbers::ZERO,
              Numbers::ZERO
          ],
          [
              Numbers::ONE,
              Numbers::ONE
          ]
      ]

      NumberMatrixConverter.new(matrix).convert.should == ['00', '11']
    end
  end

  context 'valid_checksum?' do
    let(:converter) { NumberMatrixConverter.new([]) }

    it 'validates good account numbers' do
      expect(converter.valid_checksum?('345882865')).to be
    end

    it 'invalidates bad account numbers' do
      expect(converter.valid_checksum?('555555555')).not_to be
    end
  end

  it 'replaces numbers that do not match with ? and appends ILL' do
    matrix = [
        [
            [[0, 0, 0], [1, 3, 1], [1, 0, 1], [3, 3, 3]],
            Numbers::ZERO
        ]
    ]

    NumberMatrixConverter.new(matrix).convert.should == ['?0 ILL']
  end

  context 'when multiple matches are found as alternatives for a non-number' do
    context 'when it can find a number one move away' do
      it 'uses that number instead' do
       # _     _  _  _  _  _  _
       #| || || || || || || ||_   |
       #|_||_||_||_||_||_||_| _|  |
       #
       #=> 000000051
        matrix = [
            [
                Numbers::ZERO,
                [[3,3,3],[1,3,1],[1,0,1],[3,3,3]],
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::FIVE,
                Numbers::ONE
            ]
        ]

        NumberMatrixConverter.new(matrix).convert.should == ['000000051']
      end
    end
    context 'when it can find many numbers one move away' do
      it 'uses the one that passes checksum' do
    #    _  _  _  _  _  _     _
    #|_||_|| ||_||_   |  |  | _
    #  | _||_||_||_|  |  |  | _|
    #
    #=> 490867715
        matrix = [
            [
                Numbers::FOUR,
                Numbers::NINE,
                Numbers::ZERO,
                Numbers::EIGHT,
                Numbers::SIX,
                Numbers::SEVEN,
                Numbers::SEVEN,
                Numbers::ONE,
                [[3,0,3],[3,0,3],[3,0,1],[3,3,3]]
            ]
        ]

        NumberMatrixConverter.new(matrix).convert.should == ['490867715']
      end
    end

  end

  context 'when a number does not pass checksum' do
    context 'when it can find an alternative' do
      it 'finds alternatives for numbers that do not pass checksum and appends' do
        matrix = [
            [
                Numbers::TWO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO
            ]
        ]

        NumberMatrixConverter.new(matrix).convert.should == ['200800000']
      end

      context 'when there are multiple alternatives' do
        it 'finds all possibilities' do
          matrix = [
              [
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
                  Numbers::FIVE,
              ]
          ]
          actual = NumberMatrixConverter.new(matrix).convert.first
          actual.length.should == 40
          actual.should match(/555555555 AMB/)
          actual.should match(/555655555/)
          actual.should match(/559555555/)
        end
      end
    end

    context 'when it cannot find an alternative' do
      it 'finds alternatives for numbers that do not pass checksum and appends' do
        matrix = [
            [
                Numbers::TWO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::SEVEN,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO,
                Numbers::ZERO
            ]
        ]

        NumberMatrixConverter.new(matrix).convert.should == ['200700000 ILL']
      end
    end
  end

end