require_relative 'piece'

class SlidingPiece < Piece
  def moves
    move_dirs
  end
  
  def move_dirs
    raise "implement in subclass"
  end
  
  def card_dirs
    card_dirs_master(:x, -1) + card_dirs_master(:x, 1) +
      card_dirs_master(:y, -1) + card_dirs_master(:y, 1)
  end
  
  def card_dirs_master(coord, dir)
    moves = []
    x = @pos[0]
    y = @pos[1]
    i = 0
    
    next_pos = [x, y]
    loop do
      i += 1
      next_pos = coord == :x ? [(x + (dir * i)), y] : [x, (y + (dir * i))]
      break unless Piece::on_board?(next_pos) && @board[next_pos].nil? 
      moves << next_pos  
    end
    if Piece::on_board?(next_pos) &&
         !@board[next_pos].nil? && @board[next_pos].color != self.color
      moves << next_pos
    end
    
    moves
  end
  
  def diag_dirs
    diag_dirs_master(-1, -1) + diag_dirs_master(-1, 1) + 
      diag_dirs_master(1, -1) + diag_dirs_master(1, 1)
  end
  
  def diag_dirs_master(horiz, vert)
    moves = []
    x = @pos[0]
    y = @pos[1]
    i = 0
    next_pos = [x, y]
    loop do
      i += 1
      next_pos = [(x + (horiz * i)), (y + (vert * i))]
      break unless Piece::on_board?(next_pos) && @board[next_pos].nil? 
  
      moves << next_pos  
    end
    if Piece::on_board?(next_pos) &&
         !@board[next_pos].nil? && @board[next_pos].color != self.color
      moves << next_pos
    end
    moves
  end
end