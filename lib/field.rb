class Field
  MOVES = %i[left up right down].freeze

  def initialize data
    @data = data
  end

  def orientation
    head, neck = body
    return :up unless neck

    vertical = neck[:y] - head[:y]
    horizontal = neck[:x] - head[:x]

    case
    when horizontal > 0 then :left
    when horizontal < 0 then :right
    when vertical >= 0 then :up
    when vertical < 0 then :down
    end
  end

  def view
    head = body.first

    view = [
      square(head[:x]-1, head[:y]),
      square(head[:x], head[:y]-1),
      square(head[:x]+1, head[:y]),
      square(head[:x], head[:y]+1),
    ]

    view.rotate(MOVES.index(orientation) - 1).first 3
  end

  private

  def body
    @data.dig(:you, :body)
  end

  def square x, y
    return 1 if x < 0
    return 1 if y < 0
    return 1 if x >= width
    return 1 if y >= height

    snakes_coords = snakes.flat_map { |snake| snake[:body] }
    return 1 if snakes_coords.include?({ x: x, y: y })
    return -1 if food.include?({ x: x, y: y })

    0
  end

  def width
    @data.dig(:board, :width)
  end

  def height
    @data.dig(:board, :height)
  end

  def snakes
    @data.dig(:board, :snakes)
  end

  def food
    @data.dig(:board, :food)
  end
end
