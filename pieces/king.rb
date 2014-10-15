require_relative 'stepping_piece'

class King < SteppingPiece
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