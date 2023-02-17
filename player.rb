
class Player

  attr_reader :color
  attr_accessor :position

  def initialize(color, position = nil)
    @color = color
    @position = position
  end
end
