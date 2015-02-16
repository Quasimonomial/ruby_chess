require_relative 'board'
require_relative 'piece'
# require 'debugger'
require 'colorize'
# require 'io/console'

class Array
  def element_wise_add add_this #adds by element two arrays of the same size
    [self, add_this].transpose.map{|pair| pair.reduce(:+)}
  end
end

class Game
  attr_accessor :board, :cursor, :colors, :turn
  def initialize
    @colors = [:cyan, :green]
    @board = Board.new colors
    @board.setup_game
    @cursor = [0,0]
    @board.display
    @turn = colors[1]
  end
  
  def display_board
    (0...8).each do |i|
      (0...8).each do |j|
        tile = board[[i, j]]
        if tile.nil?
          square = '-'
        else
          square = tile.rep
        end
        square = square.on_red if cursor == [i, j]
        print square
        #print "V" if cursor == [i, j]
      end
      puts
    end
  end
  
  def get_command
    STDIN.echo = false
    STDIN.raw!
    
    input = STDIN.getc.chr
    
    if input == '\e' then
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!
    
    return input
  end
    
    
  
  def get_move
    #test = io.getch
    #[pos down, pos_right]
    #not that up is down, or down is a greter row value
    
    
    move = get_command
    case move
    when "8"
      move = [-1, 0]
    when "9"
      move = [-1, 1]
    when "6"
      move = [0, 1]
    when "3"
      move = [1, 1]
    when "2"
      move = [1, 0]
    when "1"
      move = [1, -1]
    when "4"
      move = [0, -1]
    when "7"
      move = [-1, -1]
    else
      move = "QUIT"
   end
   move
  end
  
  def move_cursor
    move = get_move
    return move if !move.is_a?(Array)
    new_cursor = cursor.element_wise_add(move)
    @cursor = new_cursor if on_board? new_cursor
    puts
    puts
    puts
    puts "\e[H\e[2J"
    display_board
    return move
  end
    
  
  def on_board? pos
    return pos[0] >= 0 && pos[0] < 8 && pos[1] >= 0 && pos[1] < 8
  end
  
  def switch_turn
    if turn == colors[0]
      turn = colors[1]
    else
      turn = colors[0]
    end
  end
  
  def test
    puts
    self.display_board
    puts
    p [1, 2] == [1, 2]
    p on_board?([-1, 7])
    p on_board? [3, 3]
    p on_board? [5, 8]
    #p IO.winsize
    #while true do move_cursor end
    while true
      command = move_cursor
      break if move_cursor == "QUIT"
    end
  end
  
end

game = Game.new
game.test
#magenta is orintation -1
