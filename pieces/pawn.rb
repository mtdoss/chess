require_relative 'piece'

class Pawn < Piece
  attr_accessor :moved
  
  def initialize(board, pos, color)
    super
    @moved = false
  end
  
  def moves
    moves = move_forward + move_diag
  end
  
  def move_forward
    moves = []
    moves = @moved == false ? move_forward_times(2) : move_forward_times(1)
  end

  def direction
    color == :w ? 1 : -1
  end
  
  def move_forward_times(num)
    moves = []
    1.upto(num) do |j|
      possible_move = [@pos[0], (@pos[1] + (j * direction))]
      break unless Piece::on_board?(possible_move) && @board[possible_move].nil?
      moves << [@pos[0], (@pos[1] + (j * direction))]
    end
    
    moves
  end
  
  def move_diag
    moves = []
    possible_move1 = [@pos[0] - 1, @pos[1] + direction]
    possible_move2 = [@pos[0] + 1, @pos[1] + direction]
    
    [possible_move1, possible_move2].each do |poss_move|
      if Piece::on_board?(poss_move) && !@board[poss_move].nil? && 
                              @board[poss_move].color != color
        moves << poss_move
      end
    end
    
    moves
  end
end