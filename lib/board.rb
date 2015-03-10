class Board
  attr_accessor :grid, :colors
  def initialize (colors)
    @grid = Array.new(8){ Array.new(8, nil) }
    @colors = colors  # board can be created with initial colors b/c the board is going to create new peices with these colors; these can also be initialized in the game if we askt he players to choose thier colors
    #colors is an array of two colors
  end
  
  def [] pos
    row, col = pos
    return self.grid[row][col]
  end
  
  def []= pos, piece
    row, col = pos
    grid[row][col] = piece
  end
  
  def display
 
  end
  
  def dup #ensure we create a deep copy
    clone = Board.new(colors)
    
    self.piece_pile.each do |piece|
      duped_piece = piece.dup(clone)
      clone.place_piece(piece.pos, duped_piece)
    end
    clone
  end
  
  def find_king color
    canidates = piece_pile(color)
    king = canidates.select{ |piece| piece.is_a?(King)}[0]
    king
  end
 
  def in_check? color
    king = find_king color
    opponent = opponents(color)[0]
    piece_pile(opponent).any? do |bad_guy|
      bad_guy.moves.include?(king.pos)
    end
  end

  def in_checkmate? color
    #all_valid_moves
    #we want to check valid moves, and if there is one return true, this makes the function better
    #this does not look pretty and might be slightly bad style but I feel it is substantially cheaper in calcualtions
    piece_pile(color).all? {|piece| piece.valid_moves.empty?} && in_check?(color)#&& in_check? color
    #in_check? color
  end
  
  def move start_pos, end_pos
    return false unless 0 <= start_pos[0] && start_pos[0] <= 7 #i.e. if the user gives us a square not on the board
    return false unless 0 <= start_pos[1] && start_pos[1] <= 7
    return false unless 0 <= end_pos[0] && end_pos[0] <= 7
    return false unless 0 <= end_pos[1] && end_pos[1] <= 7
    current_piece = self[start_pos]
    return false if current_piece.nil?
    return false if !current_piece.valid_moves.include?(end_pos)
    # raise ArgumentError.new "There is no piece at start_pos!" if current_piece.nil?
    # raise ArgumentError.new "That end_pos is not valid!" if !current_piece.valid_moves.include?(end_pos)

    move! start_pos, end_pos
    return true
  end

  def move! start_pos, end_pos
    current_piece = self[start_pos]
    self[end_pos] = current_piece
    self[start_pos] = nil
    current_piece.pos = end_pos
    current_piece.is_moved = true
  end
  
  def opponents color
    #okay this only returns one opponent ever but w/e, it kinda shouldn't be an array but I think this is slightly easier
    colors.select { |a_color| a_color != color }
  end  
  
  def piece_pile color = nil
    pile = @grid.flatten()
    pile = pile.select { |piece| !piece.nil?}
    return pile.select { |piece| piece.color == color} if !color.nil?
    pile
  end
  
  def place_piece pos, piece
    self[pos] = piece
  end
  
  def setup_game
    #initalizes a new board for a new game of chess! to be called by 
    #this is a default chess game with no special rules
    #colors[0] will be on top, colors[1] will be on bottom
    #assume no pieces on board or this shit gets confusion 
    
    
    #set up pawns
    @grid[1].each_with_index do |tile, index|
      Pawn.new([1, index], colors[1], self, 1)
    end
    @grid[6].each_with_index do |tile, index|
      Pawn.new([6, index], colors[0], self, -1)
    end
    #this is terrible but lets just do it by hand not very DRY
    Rook.new([0,0], colors[1], self)
    Rook.new([0,7], colors[1], self)
    Knight.new([0,1], colors[1], self)
    Knight.new([0,6], colors[1], self)
    Bishop.new([0,2], colors[1], self)
    Bishop.new([0,5], colors[1], self)
    Queen.new([0,3], colors[1], self)
    King.new([0,4], colors[1], self)
    
    Rook.new([7,0], colors[0], self)
    Rook.new([7,7], colors[0], self)
    Knight.new([7,1], colors[0], self)
    Knight.new([7,6], colors[0], self)
    Bishop.new([7,2], colors[0], self)
    Bishop.new([7,5], colors[0], self)
    Queen.new([7,3], colors[0], self)
    King.new([7,4], colors[0], self)
      
  end
end

