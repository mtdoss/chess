require_relative '../board'
require 'debugger'

class Piece
  attr_accessor :color, :board, :pos
  
  def initialize(board, pos, color)
    @board = board
    @pos = pos # [x, y]
    @color = color
  end
  
  def inspect
    "#{self.class}-#{self.color}#{self.pos}"
  end
  
  def moves
    # raise NotImplementedError
    raise "implement in subclass"
  end
  
  def self.on_board?(coords)
    coords.all? { |coord| coord.between?(0, 7) }
  end
  
  def move_into_check?(new_pos)
    new_board = @board.deep_dup
    new_board.move!(self.pos, new_pos)
    new_board.in_check?(self.color)
  end
  
  def valid_moves
    # debugger
    moves.select do |possible_move|
      Piece.on_board?(possible_move) && 
        !self.move_into_check?(possible_move)
        
      # !self.move_into_check?(possible_move) &&
      #   Piece.on_board?(possible_move)
    end
  end
end