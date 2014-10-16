require_relative 'stepping_piece'

class King < SteppingPiece
  attr_reader :deltas
  
  def initialize(board, pos, color)
    super(board, pos, color)
    @deltas = [
      [1, 0],
      [1, -1],
      [1, 1],
      [0, -1],
      [0, 1],
      [-1, 0],
      [-1, 1],
      [-1, -1]
    ]
  end       
end