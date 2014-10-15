require_relative 'piece'

class SteppingPiece < Piece
  attr_reader :deltas
  
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