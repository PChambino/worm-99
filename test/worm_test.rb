require 'worm'

class WormTest < Minitest::Test
  def test_moves_relative_to
    worm = Worm.new
    assert_equal %i[left up right], worm.moves_relative_to(:up)
    assert_equal %i[up right down], worm.moves_relative_to(:right)
    assert_equal %i[right down left], worm.moves_relative_to(:down)
    assert_equal %i[down left up], worm.moves_relative_to(:left)
  end

  def test_move
    assert_move :up, [1, 0, 0], :left
    assert_move :up, [0, 1, 0], :up
    assert_move :up, [0, 0, 1], :right
    assert_move :right, [1, 0, 0], :up
    assert_move :right, [0, 1, 0], :right
    assert_move :right, [0, 0, 1], :down
    assert_move :down, [1, 0, 0], :right
    assert_move :down, [0, 1, 0], :down
    assert_move :down, [0, 0, 1], :left
    assert_move :left, [1, 0, 0], :down
    assert_move :left, [0, 1, 0], :left
    assert_move :left, [0, 0, 1], :up
  end

  def assert_move orientation, outputs, move
    view = Object.new

    field = mock
    field.expect :orientation, orientation
    field.expect :view, view

    brain = mock
    brain.expect :compute, outputs, [view]

    worm = Worm.new brain: brain
    assert_equal move, worm.move(field)
  end

  def mock
    Minitest::Mock.new
  end
end
