require 'colorize'

class Game
  def populate_board
  end
end

class Board
  attr_accessor :piece_pile

  def initialize
    @piece_pile = []
  end
  
  def deep_copy
    clone = Board.new
    clone.piece_pile = piece_pile.map { |piece| piece.deep_copy }
    clone
  end
  
  def display
    grid = Array.new(8){ Array.new(8){"-"} }
    piece_pile.each do |piece|
      grid[piece.row][piece.col] = piece.rep
    end
    grid.each do |row|
      row.each do |element|
        print element
      end
      puts
    end
    puts
  end
  
  def move row, col, piece
    piece.move(row, col)
  end
  
  
  def valid_move? row, col, piece
    return false if piece.valid_move?(row, col)
  
  end
  
  def collision?(r1, c1, r2, c2)
    rows = (r1..r2).to_a
    cols = (c1..c2).to_a
    return false if rows.length != cols.length
    [rows, cols].transpose
  end
  
  def talk_to_pieces
  end
  
  def in_check?
  end
  
  def in_checkmate?
  end
  
  
  
end

class Piece
  attr_accessor :row, :col, :rep, :color, :board
  
  def initialize(row, col, color, board)
    @row = row
    @col = col
    @board = board
    @color = color
  end
  
  def deep_copy
    clone = self.class.new(row, col, board)
  end
  
  def move r, c
    if valid_move? r, c
      @row = r
      @col = c
    end
  end
  
  def valid_move? r, c
    [r, c] != [row, col]
  end
  
end

class Rook < Piece
  def initialize(row, col, color, board)
    super(row, col, color, board)
    @rep = "R".colorize(:blue)
  end
  
  
  def valid_move? r, c
    return false if !super
    if (row == r || col == c)
      return true
    end
    return false
  end
  #def
  # => check peice moving logic  
  # => check for colisions
  # => check check/checkmate
  #
  
  
end

bored = Board.new

rook = Rook.new(3, 3, bored)
bored.piece_pile << rook
bored.display
bored.move(7, 7, rook)
bored.display
