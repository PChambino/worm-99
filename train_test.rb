require 'minitest'
require 'minitest/pride'
Minitest.autorun

require_relative 'train'

class WormTest < Minitest::Test
  def setup
    @worm = Worm.new
  end

  def test_moves_relative_to
    assert_equal %i[left up right], @worm.moves_relative_to(:up)
    assert_equal %i[up right down], @worm.moves_relative_to(:right)
    assert_equal %i[right down left], @worm.moves_relative_to(:down)
    assert_equal %i[down left up], @worm.moves_relative_to(:left)
  end
end
