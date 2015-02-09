#how to colorize pieces
#this file requires colorize
# we should pass the color as a symbol of the color we want
#  
#
# Also for fun here is the colorize colors hash
#  COLORS = {
#    :black          => 0,
#    :red            => 1,
#    :green          => 2,
#    :yellow         => 3,
#    :blue           => 4,
#    :magenta        => 5,
#    :cyan           => 6,
#    :white          => 7,
#    :default        => 9,
#  
#    :light_black    => 60,
#    :light_red      => 61,
#    :light_green    => 62,
#    :light_yellow   => 63,
#    :light_blue     => 64,
#    :light_magenta  => 65,
#    :light_cyan     => 66,
#    :light_white    => 67
#  }
#  
  
  
class Piece
  attr_accessor :pos, :rep, :color, :board
  DIAGONAL = [1, 1], [1, -1], [-1, 1], [-1, -1]
  CARDINAL = [0, 1], [1, 0], [-1, 0], [0, -1]
  
  def initialize pos, color, board
    @pos = pos
    @rep = rep #rep will be passed as a char/char string, so we can so
    #can do something like rep.colorize(color) for an arbitrary color symbol
    @color = color
    @board = board
    board[pos] = self
  end

  def dup new_board = board
    clone = self.class.new(pos.dup, color, new_board)
  end
  
  def move_into_check? new_pos
    clone = board.dup
    clone.move!(pos, new_pos)
    clone.in_check? color
  end
  
  def on_board? pos
    row, col = pos
    (0...8).include?(row) && (0...8).include?(col)
  end
  
  def to_s
    "#{@pos} #{@rep}"
  end
  
  def valid_moves
    moves.select {|move| !move_into_check? move }
  end
    
end

class Pawn < Piece
  attr_accessor :orientation
  
  def initialize pos, color, board, orientation 
    #orinetation is 1 or -1 
    super pos, color, board
    @rep = "P".colorize(@color)
    @orientation = orientation
  end
  
  def dup new_board = board
    clone = self.class.new(pos.dup, color, new_board, orientation)
  end   
  
  def moves
    moves = []
    forward = pos.element_wise_add [1 * orientation, 0]
    diag_right   =  pos.element_wise_add [1 * orientation, 1 * orientation]
    diag_left    =  pos.element_wise_add [1 * orientation, -1 * orientation]
    forward_twice =  pos.element_wise_add [2 * orientation, 0]
    
    moves << forward if on_board?(forward) && !board[forward].is_a?(Piece) 
    moves << diag_right if on_board?(diag_right) &&
                           board[diag_right].is_a?(Piece) &&
                           board[diag_right].color != self.color
    moves << diag_left if on_board?(diag_left) &&
                          board[diag_left].is_a?(Piece) &&
                          board[diag_left].color != self.color
    moves << forward_twice if on_board?(forward_twice) && 
                             !board[forward_twice].is_a?(Piece) &&
                             !board[forward].is_a?(Piece) &&
                             !is_moved?
                             
    moves
  end 
end


class Stepper < Piece
  attr_accessor :move_set
  def moves
    moves = []
    @move_set.each do |dir|
      pos_current = pos
      
      pos_current = pos_current.element_wise_add dir
      next if !on_board? pos_current
      if board[pos_current].is_a?(Piece)
        moves << pos_current if board[pos_current].color != self.color
      else
        moves << pos_current
      end
    end
    moves
  end
end

class Knight < Stepper
  def initialize *args
    super
    @move_set = [[2, 1], [1, 2], [-1, -2], [-2, -1], 
                 [2, -1], [1, -2], [-1, 2], [-2, 1]]
    @rep = "N".colorize(@color)
  end
end



class King < Stepper # is a royal piece
  def initialize *args
    super
    @move_set = DIAGONAL + CARDINAL
    @rep = "K".colorize(@color)
  end
end


class Rider < Piece
  attr_accessor :move_dirs
  
  def moves
    moves = []
    @move_dirs.each do |dir|
      pos_current = pos
      loop do
        pos_current = pos_current.element_wise_add dir
        break if !on_board? pos_current
        if board[pos_current].is_a?(Piece)
          moves << pos_current if board[pos_current].color != self.color 
          break
        end
        moves << pos_current
      end
    end
    moves
  end  
end

class Queen < Rider
  def initialize *args
    super
    @move_dirs = DIAGONAL + CARDINAL
    @rep = "Q".colorize(@color)
  end
end

class Bishop < Rider
  def initialize *args
    super
    @move_dirs = DIAGONAL
    @rep = "B".colorize(@color)
  end
end



class Rook < Rider
  def initialize *args
    super
    @move_dirs = CARDINAL
    @rep = "R".colorize(@color)
  end
end 