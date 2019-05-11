require 'set'

class Worm
  MOVES = %i[left up right down].freeze

  def initialize
    @brain = Brain.new inputs: 3, outputs: 3
  end

  def init!
    @brain.init!
  end

  def move field
    moves_relative_to(orientation)
      .zip(@brain.compute field.view)
      .max_by { |(_, value)| value }
      .first
  end

  def moves_relative_to orientation
    MOVES.rotate(MOVES.index(orientation) - 1).first(3)
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
    self
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

class Field
  def initialize data
    @data = data
  end
end

seed = ARGV[0]&.to_i || Random.new_seed
srand seed
puts 'seed', seed

inputs = [
  [0, 0, 1],
  [0, 1, 0],
  [0, 1, 1],
  [1, 0, 0],
  [1, 0, 1],
  [1, 1, 0],
]
outputs = [:straight, :left, :right]

brains = 10.times.map { Brain.new(inputs: 3, outputs: 3).init! }
brains_fitness = brains.map do |brain|
  inputs.map do |input|
    output = brain.compute input
    direction = outputs.zip(output)
      .max_by { |(_, value)| value }
      .first

    direction_input =
      case direction
      when :left then input[0]
      when :straight then input[1]
      when :right then input[2]
      end

    # puts '---'
    # puts input.inspect
    # puts [output, direction.zero? ? 'good' : 'bad'].inspect

    direction_input.zero? ? input.count(1) : 0
  end.sum
end
puts brains_fitness.inspect
