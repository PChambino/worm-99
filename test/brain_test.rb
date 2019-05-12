require 'brain'

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
