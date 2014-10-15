require_relative 'sliding_piece'

class Rook < SlidingPiece
  def move_dirs
    card_dirs
  end
end