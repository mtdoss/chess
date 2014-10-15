# encoding: utf-8

require_relative 'board'

class InvalidInputError < ArgumentError
end

class Game
  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(@board, :w)
    @player2 = HumanPlayer.new(@board, :b)
  end
  
  def play
    player = @player1
    self.display
    until @board.checkmate?(:w) || @board.checkmate?(:b)
      player_color = player.color == :w ? "White" : "Black"
      puts "It is #{player_color}'s turn"
      player.play_turn
      self.display
      player = player == @player1 ? @player2 : @player1
    end
    puts @board.checkmate?(:w) ? "Black wins!" : "White wins!"
  end
  
  def display
    board_border = 8
    x, y = 0, 7
    until board_border == 0
      x = 0
      print "#{board_border} | "
      until x > 7
        piece = @board[[x, y]]
        if piece.nil?
          print "  | "
        else
          icon = [piece.class.to_s, piece.color]
          print "#{return_icon( icon[0], icon[1] ) } | "
        end
        x += 1
      end
      print "\n"
      y -= 1
      board_border -= 1
    end
    puts "    a   b   c   d   e   f   g   h "
  end
  
  def return_icon(type, color)
    icon = "\u2713"
    i = color == :w ? 0 : 1
    hash = {}
    hash["King"] = ["\u2654", "\u265a"]
    hash["Queen"] = ["\u2655", "\u265b"]
    hash["Rook"] = ["\u2656", "\u265c"]
    hash["Bishop"] = ["\u2657", "\u265d"]
    hash["Knight"] = ["\u2658", "\u265e"]
    hash["Pawn"] = ["\u2659", "\u265f"]
    hash[type][i]
  end
end

class HumanPlayer
  attr_accessor :color, :board
  
  def initialize(board, color)
    @board = board
    @color = color
  end
  
  def play_turn 
    puts "Select your move in coordinate-form, e.g. e2, e4"
    input = parse(gets.chomp)
    if self.color != @board[input[0]].color
      raise InvalidMoveError, "That's not your color"
    end
    @board.move(input[0], input[1])
  rescue InvalidMoveError => e
    puts "Error was: #{e.message}"
    retry
  end
  
  def parse(input)
    raise InvalidMoveError, "Invalid input!" unless valid_input?(input)
    positions = input.split(', ')
    current_pos = convert_coords(positions[0])
    next_pos = convert_coords(positions[1])
    [current_pos, next_pos]
  end
  
  def valid_input?(input)
    return true unless (input =~ /[a-h][1-8],\s[a-h][1-8]/).nil?
    
    false
    # !(input =~ /[a-h][1-8],\s[a-h][1-8]/).nil?
  end
  
  def convert_coords(coords)
    index_arr = (:a..:h).to_a  
    x = index_arr.index(coords[0].to_sym)
    y = coords[1].to_i - 1
    [x, y]
  end
end

g = Game.new
g.play