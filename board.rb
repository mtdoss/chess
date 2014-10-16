require_relative './pieces'

class InvalidMoveError < ArgumentError 
end

class Board
  attr_accessor :grid
  
  def initialize(fill_board = true)
    @grid = Array.new(8) { Array.new(8) }
    set_pieces if fill_board
  end
  
  def set_pieces
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    
    [[0, :w], [7, :b]].each do |(y, color)|
      pieces.each_with_index do |klass, x|
        self[[x, y]] = klass.new(self, [x, y], color)
      end
    end
    
    [[1, :w], [6, :b]].each do |(y, color)|
      0.upto(7) do |x|
        self[[x, y]] = Pawn.new(self, [x, y], color)
      end
    end
  end
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end
  
  def is_empty?(pos)
    @grid[pos].empty?
  end
  
  def in_check?(color)
    opponents_color = color == :w ? :b : :w
    opponents_pieces = get_pieces_of_color(opponents_color)
    opponents_pieces.each do |piece|
      return true if piece.moves.include?(find_king(color))
    end
    false
  end
  
  def checkmate?(color)
    return false unless in_check?(color)
    all_pieces = get_pieces_of_color(color)
    all_pieces.none? { |piece| piece.valid_moves.count > 0 }
  end
  
  def move!(start, end_pos)
    piece = self[start]
    piece.pos = end_pos
    # debugger
    self[end_pos] = piece
    self[start] = nil
    if piece.class == Pawn
      piece.moved = true
      promotion(piece.pos, piece.color) if promote?(piece)
    end
  end
  
  def move(start, end_pos)
    raise InvalidMoveError, "Starting position nil" if self[start].nil?
    piece = self[start]
    raise InvalidMoveError, "Can't do that" unless piece.moves.include?(end_pos)
    unless piece.valid_moves.include?(end_pos)
      raise InvalidMoveError, "Can't move into check"
    end    
    move!(start, end_pos)
  end
  
  def find_king(color)
    kings = get_pieces_of_color(color).select { |p| p.class == King }
    kings.first.pos
  end
  
  def promote?(piece)
    color = piece.color
    last_row = color == :w ? 7 : 0
    piece.pos[1] == last_row
  end

  def promotion(pos, color)
    self[pos] = Queen.new(self, pos, color)
  end

  def pieces

  end

  def get_pieces_of_color(color)
    @grid.flatten.select do |el|
      !el.nil? && el.color == color
    end
  end
  
  def deep_dup
    duped = Board.new(false)
    @grid.each_index do |row|
      @grid.each_index do |col| # maybe 8.times?
        next if @grid[row][col].nil?
        piece = @grid[row][col]
        duped[[row, col]] = piece.class.new(duped, [row,col], piece.color)
      end
    end
    duped
  end
end