class Field
  def initialize data
    @data = data
  end

  def orientation
    head, neck = @data.dig(:you, :body)
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
end
