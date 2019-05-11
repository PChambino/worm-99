require 'set'

class Worm
  MOVES = %w[up down left right].freeze

  def move(inputs)
    MOVES.sample
  end
end

class Brain
  def initialize(inputs:, outputs:)
    @inputs = inputs.times.map { Node.new }
    @outputs = outputs.times.map { |name| Node.new }
    @layers = [@outputs]
  end

  def init!
    @links = @inputs.flat_map do |input|
      @outputs.map do |output|
        Link.new(input: input, output: output, weight: rand, innovation: 1)
      end
    end
  end

  def compute(inputs)
    @inputs.zip(inputs).each { |node, value| node.value = value }
    @layers.each { |layer| layer.each { |node| node.compute } }
    @outputs.map { |node| node.value }
  end

  class Node
    attr_accessor :value

    def initialize
      @value = 0
      @inputs = Set[]
    end

    def enable(input)
      @inputs.add(input)
    end

    def disable(input)
      @inputs.remove(input)
    end

    def compute
      sum = @inputs.sum { |input| input.compute }
      @value = 2 / (1 + Math::E ** (-2 * sum)) - 1
    end
  end

  class Link
    # attr_reader :input, :output, :weight, :innovation

    def initialize(input:, output:, weight:, innovation:)
      @input, @output, @weight, @innovation = input, output, weight, innovation
      @output.enable(self)
    end

    def compute
      @input.value * @weight
    end

    def disable
      @output.disable(self)
    end
  end
end

brain = Brain.new(inputs: 3, outputs: 3)
brain.init!
puts brain.compute([0, 1, 0])
