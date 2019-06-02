require 'field'

class FieldTest < Minitest::Test
  def test_orientation
    assert_orientation [{ x: 3, y: 3 }], :up
    assert_orientation [{ x: 3, y: 3 }, { x: 3, y: 3 }], :up
    assert_orientation [{ x: 3, y: 3 }, { x: 3, y: 4 }], :up
    assert_orientation [{ x: 3, y: 3 }, { x: 3, y: 2 }], :down
    assert_orientation [{ x: 3, y: 3 }, { x: 4, y: 3 }], :left
    assert_orientation [{ x: 3, y: 3 }, { x: 2, y: 3 }], :right
    assert_orientation [{ x: 3, y: 3 }, { x: 2, y: 3 }, { x: 1, y: 3 }], :right
  end

  def assert_orientation body, orientation
    assert_equal orientation, Field.new(you: { body: body }).orientation
  end
end
