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
    puts command
    command_letters = command.split("")
    p command_letters
    puts origin_y = command_letters[0].ord - 97
    puts origin_x = 8 - command_letters[1].to_i
    puts destination_y = command_letters[2].ord - 97
    puts destination_x = 8 - command_letters[3].to_i
    @board.move([origin_x, origin_y], [destination_x, destination_y])
    # command_letters. do |letter|
    #   letter = letter.to_i
    # end
    # board.move([command_letters[0], command_letters[1] ] , 
      # [command_letters[2], command_letters[3]])
  end

  def switch_turn
    if @turn == colors[0]
      @turn = colors[1]
    else
      @turn = colors[0]
    end
  end
  
  def start_game
    self.take_turn
  end

  def take_turn
    puts "The Board Position is:"
    self.display_board
    puts "#{@turn}, it is your turn."
    puts "command?"
    command = gets.chomp
    self.process_command command
    self.switch_turn
    self.take_turn

  end

  def test
    puts
    self.display_board
    puts
    p [1, 2] == [1, 2]
    p on_board?([-1, 7])
    p on_board? [3, 3]
    p on_board? [5, 8]
    board.move([6, 4], [4, 4])
    self.display_board
    puts
    board.move([1, 4], [3, 4])
    self.display_board
    puts
    board.move([7, 3], [3, 7])
    self.display_board
    puts
    board.move([0, 1], [2, 2])
    self.display_board
    puts
    board.move([7, 5], [4, 2])
    self.display_board
    puts
    board.move([0, 6], [2, 5])
    self.display_board
    puts
    board.move([3, 7], [1, 5])
    self.display_board
    puts
    p @board.in_checkmate? 0
    p @board.in_checkmate? 1
  end

  
end

game = Game.new
game.start_game
#magenta is orintation -1
