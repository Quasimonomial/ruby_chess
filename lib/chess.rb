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
    @colors = [:white, :red]
    @board = Board.new colors
    @board.setup_game
    @cursor = [0,0]
    @board.display
    @turn = colors[0]
  end
  
  def display_board
    print "  abcdefgh\n"
    (0...8).each do |i|
      print (8 - i)
      print " "
      (0...8).each do |j|
        tile = board[[i, j]]
        if tile.nil?
          square = '-'
        else
          square = tile.rep
        end
        print square
      end
      puts
    end
  end
  
  def on_board? pos
    return pos[0] >= 0 && pos[0] < 8 && pos[1] >= 0 && pos[1] < 8
  end
  
  def process_command command
    command_letters = command.split("")
    origin_y = command_letters[0].ord - 97
    origin_x = 8 - command_letters[1].to_i
    destination_y = command_letters[2].ord - 97
    destination_x = 8 - command_letters[3].to_i
    return @board.move([origin_x, origin_y], [destination_x, destination_y], @turn)
  end

  def switch_turn
    if @turn == colors[0]
      @turn = colors[1]
    else
      @turn = colors[0]
    end
  end
  
  def start_game
    puts "Welcome to chess!  Putting in moves simply requires you to type them in in this format."
    puts "'a2a4', for example, moves white's rook pawn ahead too spaces."
    puts "Remember, you can never end a turn if you are in check."
    self.take_turn
  end

  def take_turn
    puts "The Board Position is:"
    self.display_board
    if @board.in_checkmate? @turn
      puts "#{@turn} has been checkmated!"
      self.switch_turn
      puts "#{@turn} has achieved Victory!"
      return
    end
    puts "#{@turn}, it is your turn."
    loop do 
      puts "command?"
      command = gets.chomp
      break if self.process_command command
      puts "that move is invalid"
    end
    self.switch_turn
    self.take_turn

  end 
end

game = Game.new
game.start_game

