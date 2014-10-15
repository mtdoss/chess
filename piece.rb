require_relative 'board'

class Piece
  attr_accessor :color, :board, :pos
  def initialize(board, pos, color)
    @board = board
    @pos = pos # [x, y]
    @color = color
  end
  
  def inspect
    return "#{self.class}-#{self.color}#{self.pos}"
  end
  
  def moves
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
    moves.select { |possible_move| !self.move_into_check?(possible_move) }
  end
end

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

class Bishop < SlidingPiece
  def move_dirs
    diag_dirs
  end
end

class Rook < SlidingPiece
  def move_dirs
    card_dirs
  end
end

class Queen < SlidingPiece
  def move_dirs
    card_dirs + diag_dirs
  end
end

class SteppingPiece < Piece
  attr_reader :deltas
  
  def initialize(board, pos, color)
    super(board, pos, color)
  end
  
  def moves
    moves = @deltas.map do |delta|
      [@pos[0] + delta[0], @pos[1] + delta[1]]
    end
    moves.select do |coords|
      Piece::on_board?(coords) && !@board[coords].nil? &&
          @board[coords].color != self.color
    end  
  end  
end

class Knight < SteppingPiece
  def initialize(board, pos, color)
    super(board, pos, color)
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

class Pawn < Piece
  attr_accessor :moved
  
  def initialize(board, pos, color)
    super(board, pos, color)
    @moved = false
  end
  
  def moves
    moves = move_forward + move_diag
  end
  
  def move_forward
    moves = []
    moves = @moved == false ? move_forward_times(2) : move_forward_times(1)
  end
  
  def move_forward_times(num)
    color == :w ? i = 1 : i = -1
    moves = []
    1.upto(num) do |j|
      possible_move = [@pos[0], (@pos[1] + (j * i))]
      break unless Piece::on_board?(possible_move) && @board[possible_move].nil?
      moves << [@pos[0], (@pos[1] + (j * i))]
    end
    
    moves
  end
  
  def move_diag
    color == :w ? i = 1 : i = -1
    moves = []
    possible_move1 = [@pos[0] - 1, @pos[1] + i]
    possible_move2 = [@pos[0] + 1, @pos[1] + i]
    
    [possible_move1, possible_move2].each do |poss_move|
      if Piece::on_board?(poss_move) && !@board[poss_move].nil? && 
                              @board[poss_move].color != color
        moves << poss_move
      end
    end
    
    moves
  end
end