
class Player

  attr_reader :color, :position

  def initialize(color, position = nil)
    @color = color
    @position = position
  end
end
