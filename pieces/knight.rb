require_relative 'stepping_piece'

class Knight < SteppingPiece
  attr_reader :deltas
  
  def initialize(board, pos, color)
    super
    @deltas = [
      [1, 2],
      [1, -2],
      [2, 1],
      [2, -1],
      [-1, 2],
      [-1, -2],
      [-2, 1],
      [-2, -1]
    ] 
  end
end