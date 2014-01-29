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
            [[0, 0, 0], [1, nil, 1], [1, 0, 1], [nil, nil, nil]],
            Numbers::ZERO
        ]
    ]

    NumberMatrixConverter.new(matrix).convert.should == ['?0 ILL']
  end

  context 'when a number does not pass checksum' do
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

end