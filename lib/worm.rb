require 'brain'

class Worm
  MOVES = %i[left up right down].freeze

  def initialize **options
    @brain = options.fetch(:brain) { Brain.new inputs: 3, outputs: 3 }
  end

  def init!
    @brain.init!
  end

  def move field
    moves_relative_to(field.orientation)
      .zip(@brain.compute field.view)
      .max_by { |(_, value)| value }
      .first
  end

  def moves_relative_to orientation
    MOVES.rotate(MOVES.index(orientation) - 1).first 3
  end
end

class Field
  def initialize data
    @data = data
  end
end
