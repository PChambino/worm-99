require 'field'

class FieldTest < Minitest::Test
  def test_orientation
    field = Field.new(
      you: {
        body: {
        }
      }
    )
    assert_equal :up, field.orientation
  end
end
