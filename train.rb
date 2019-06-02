#!/usr/bin/env bundle exec ruby -Ilib

require 'brain'

seed = ARGV[0]&.to_i || Random.new_seed
srand seed
puts 'seed', seed

INPUTS = [
  [0, 0, 1],
  [0, 1, 0],
  [0, 1, 1],
  [1, 0, 0],
  [1, 0, 1],
  [1, 1, 0],
]
OUTPUTS = %i[left up right]

def fitness brain
  INPUTS.map do |input|
    output = brain.compute input
    direction = OUTPUTS.zip(output)
      .max_by { |(_, value)| value }
      .first

    direction_input =
      case direction
      when :left then input[0]
      when :up then input[1]
      when :right then input[2]
      end

    # puts '---'
    # puts input.inspect
    # puts [output, direction.zero? ? 'good' : 'bad'].inspect

    direction_input.zero? ? input.count(1) : 0
  end.sum
end

brains = 10.times.map { Brain.new(inputs: 3, outputs: 3).init! }
brains_fitness = brains.map { |brain| fitness brain }
puts brains_fitness.inspect
