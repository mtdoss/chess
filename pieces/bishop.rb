require_relative 'sliding_piece'

class Bishop < SlidingPiece
  def move_dirs
    diag_dirs
  end
end