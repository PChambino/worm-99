require 'minitest'
require 'minitest/mock'
require 'minitest/pride'
Minitest.autorun

require_relative 'train'

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

class BrainTest < Minitest::Test
  def test_link_and_node_compute
    inputA = Brain::Node.new value: 3
    inputB = Brain::Node.new value: 5
    output = Brain::Node.new
    linkA = Brain::Link.new input: inputA, output: output, weight: 0.5, innovation: 1
    linkB = Brain::Link.new input: inputB, output: output, weight: 0.1, innovation: 1
    assert_equal 1.5, linkA.compute
    assert_equal 0.5, linkB.compute
    assert_in_delta 0.964, output.compute

    linkB.disable
    assert_in_delta 0.905, output.compute
  end

  def test_compute
    seed = srand 123
    brain = Brain.new inputs: 3, outputs: 3
    brain.init!
    assert_equal [0.9107796888733759, 0.8862772959917198, 0.7182585363587206],
      brain.compute([0, 1, 1])
  ensure
    srand seed
  end
end
