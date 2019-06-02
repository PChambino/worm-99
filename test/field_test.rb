require 'field'

class FieldTest < Minitest::Test
  def test_orientation
    assert_orientation [[3, 3]], :up
    assert_orientation [[3, 3], [3, 3]], :up
    assert_orientation [[3, 3], [3, 4]], :up
    assert_orientation [[3, 3], [3, 2]], :down
    assert_orientation [[3, 3], [4, 3]], :left
    assert_orientation [[3, 3], [2, 3]], :right
    assert_orientation [[3, 3], [2, 3], [1, 3]], :right
  end

  def assert_orientation body, orientation
    assert_equal orientation, Field.new(you: map_snake(body)).orientation
  end

  def test_view_corners
    assert_view [1, 1, 0], [[0, 0]]
    assert_view [0, 1, 1], [[0, 0], [1, 0]]
    assert_view [0, 1, 1], [[4, 0]]
    assert_view [1, 1, 0], [[4, 0], [3, 0]]
    assert_view [1, 1, 0], [[0, 4], [1, 4]]
    assert_view [0, 1, 1], [[0, 4], [0, 3]]
    assert_view [1, 1, 0], [[4, 4], [4, 3]]
    assert_view [0, 1, 1], [[4, 4], [3, 4]]
  end

  def test_view_snakes
    assert_view [0, 1, 0], [[3, 3]], [[3, 2]]
    assert_view [0, 1, 0], [[3, 3], [3, 2]], [[3, 4]]
    assert_view [0, 0, 1], [[3, 3], [2, 3], [2, 4], [3, 4]]
  end

  def assert_view view, you, *snakes, board: { height: 5, width: 5 }
    mapped_snakes = ([you] + snakes).map(&method(:map_snake))

    assert_equal view, Field.new(
      board: board.merge(snakes: mapped_snakes),
      you: mapped_snakes.first,
    ).view
  end

  def map_snake snake
    { body: snake.map { |(x, y)| { x: x, y: y } } }
  end
end
