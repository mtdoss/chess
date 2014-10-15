require_relative 'piece'
require 'debugger'

class InvalidMoveError < ArgumentError 
end

class Board
  attr_accessor :grid
  
  def initialize(fill_board = true)
    @grid = Array.new(8) { Array.new(8) }
    set_pieces if fill_board
  end
  
  def set_pieces
    self[[0,0]] = Rook.new(self, [0, 0], :w)
    self[[1, 0]] = Knight.new(self, [1, 0], :w)
    self[[2, 0]] = Bishop.new(self, [2, 0], :w)
    self[[3, 0]] = Queen.new(self, [3, 0], :w)
    self[[4, 0]] = King.new(self, [4, 0], :w)
    self[[5, 0]] = Bishop.new(self, [5, 0], :w)
    self[[6, 0]] = Knight.new(self, [6, 0], :w)
    self[[7, 0]] = Rook.new(self, [7, 0], :w)
    
    0.upto(7) do |index|
      self[[index, 1]] = Pawn.new(self, [index, 1], :w)
    end
    
    self[[0,7]] = Rook.new(self, [0, 7], :b)
    self[[1, 7]] = Knight.new(self, [1, 7], :b)
    self[[2, 7]] = Bishop.new(self, [2, 7], :b)
    self[[3, 7]] = Queen.new(self, [3, 7], :b)
    self[[4, 7]] = King.new(self, [4, 7], :b)
    self[[5, 7]] = Bishop.new(self, [5, 7], :b)
    self[[6, 7]] = Knight.new(self, [6, 7], :b)
    self[[7, 7]] = Rook.new(self, [7, 7], :b)
    
    0.upto(7) do |index|
      self[[index, 6]] = Pawn.new(self, [index, 6], :b)
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
    self[end_pos] = piece
    self[start] = nil
    piece.moved = true if piece.class == Pawn   
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
    king = @grid.flatten.select do |el|
      !el.nil? && el.color == color && el.class == King
    end
    king[0].pos
  end
  
  def get_pieces_of_color(color)
    @grid.flatten.select do |el|
      !el.nil? && el.color == color
    end
  end
  
  def deep_dup
    duped = Board.new(false)
    @grid.each_index do |row|
      @grid.each_index do |col|
        next if @grid[row][col].nil?
        piece = @grid[row][col]
        duped[[row, col]] = piece.class.new(duped, [row,col], piece.color)
      end
    end
    duped
  end
end