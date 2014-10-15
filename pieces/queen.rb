require_relative 'sliding_piece'

class Queen < SlidingPiece
  def move_dirs
    card_dirs + diag_dirs
  end
end