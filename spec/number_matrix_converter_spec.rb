require_relative '../src/number_matrix_converter'
require_relative '../lib/numbers'

describe NumberMatrixConverter do
  include Numbers

  it 'converts a matrix to an account number' do
    matrix = [
        [
            [[nil, 0, nil], [1, nil, 1], [1, 0, 1], [nil, nil, nil]],
            [[nil, 0, nil], [1, nil, 1], [1, 0, 1], [nil, nil, nil]]
        ],
        [
            [[nil, nil, nil], [nil, nil, 1], [nil, nil, 1], [nil, nil, nil]],
            [[nil, nil, nil], [nil, nil, 1], [nil, nil, 1], [nil, nil, nil]]
        ]
    ]

    NumberMatrixConverter.new(matrix).convert.should == ['00','11']
  end
end