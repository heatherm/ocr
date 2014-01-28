require_relative '../src/number_matrix_converter'
require_relative '../lib/numbers'

describe NumberMatrixConverter do
  include Numbers

  it 'converts a matrix to an account number' do
    NumberMatrixConverter.any_instance.stub(:valid?).and_return(true)
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

    NumberMatrixConverter.new(matrix).convert.should == ['00','11']
  end

  it 'validates account numbers' do
    converter = NumberMatrixConverter.new([])
    expect(converter.valid?('345882865')).to be
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

  it 'replaces numbers that do not pass checksum and appends ERR' do
    matrix = [
        [
            Numbers::ONE,
            Numbers::ONE
        ]
    ]

    NumberMatrixConverter.new(matrix).convert.should == ['11 ERR']
  end

end