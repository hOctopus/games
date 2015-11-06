class TicTacToe

  # hash of winning patterns to check against each player's history of moves
  WINNERS = {
    top_row: [1,2,3],
    center_row: [4,5,6],
    bottom_row: [7,8,9],
    left_col: [1,4,7],
    center_col: [2,5,8],
    right_col: [3,6,9],
    diag_left: [1,5,9],
    diag_right: [3,5,7]
  }

  # sets the starting properties of the players and the game board
  # calls the methods that handle gameplay
  def self.main
    @player1 = Player.new :mark => "X", :plays => Array.new
    @player2 = Player.new :mark => "O", :plays => Array.new
    @win = @tie = false
    @board = {
      row1: [1,2,3],
      row2: [4,5,6],
      row3: [7,8,9]
    }
    puts "Lets begin! Type \"quit\" or just Q and press enter to exit the game at any time."
    puts "Player One, enter name."
    @player1.name=gets.chomp
    puts "Welcome, #{@player1.name}! You are #{@player1.mark}." unless quit(@player1.name)
    puts "Player Two, enter name."
    @player2.name=gets.chomp
    puts "Welcome, #{@player2.name}! You are #{@player2.mark}." unless quit(@player2.name)
    game([@player1, @player2])
    show_board
    puts "Thanks for playing, #{@player1.name} and #{@player2.name}!"
  end

  private

  # handles the methods and variables needed to play and determine a win or a tie
  def self.game(players)
    until @win || @tie
      players.each { |player|
        player.plays << play(player)
        check_win(player.plays)
        if @win
          puts "#{player.name} won the game!"
          break
        elsif @tie
          puts "Tie game! No winners, but no losers either!"
          break
        end
      }
    end
  end

  # main gameplay method, provides instructions and takes player input as moves, making sure each move is valid
  # returns the player's move as integer to store in player's history of moves for checking against winning patterns
  def self.play(player)
    puts "#{player.name}, choose a position on the game board."
    puts "Board positions are numbered left to right and top to bottom."
    puts "Current board:"
    show_board
    puts "Row 1 = squares 1, 2, and 3"
    puts "Row 2 = squares 4, 5, and 6"
    puts "Row 3 = squares 7, 8, and 9"
    puts "Careful not to choose a square already filled!"
    puts "To exit the game, type \"quit\" or the letter Q and press enter."
    move = gets.chomp
    while !quit(move) && move =~ /[^1-9]/ || ( @player1.plays.include?(move.to_i) || @player2.plays.include?(move.to_i) )
      puts "That's not a valid move, #{player.name}. Please try again."
      move = gets.chomp
    end
    move = move.to_i
    update_board(player, move)
    move
  end

  # determines if either player has played a winning pattern
  # if no win, checks if there is a tie -- board is filled / all moves made with no winners
  # the last move that can possibly be made is Player One's fifth move
  def self.check_win(plays)
    WINNERS.each { |key, check|
      return @win = true if (check - plays).empty?
    }
    return @tie = true if plays.size > 4
  end

  # updates board position with Xs and Os based on player moves
  def self.update_board(player,move)
    @board.update(@board) { |row, squares|
      squares.each_with_index { |square, index|
        squares[index] = player.mark if square == move
      }
    }
  end

  # shows a simple graphic of the current state of the board
  def self.show_board
    print "\n"
    @board.each { |row, squares|
      graphic = squares.map { |square|
        square.is_a?(String) ? square : square = " "
        row == :row3 ? square : square = "\e[4m#{square}\e[0m"
      }
      puts graphic.join("|")
    }
    print "\n"
  end

  # allows either player to end the game at any point the game prompts for input
  def self.quit(entry)
    if entry.downcase == "quit" || entry.downcase == "q"
      abort("Quitting game. Thanks for playing!")
    else
      return false
    end
  end

  # without players, there can be no game...
  class Player

    attr_accessor :name, :mark, :plays

    def initialize(params)
      @name = params[:name] # name entered at the console
      @mark = params[:mark] # X for Player 1 and O for Player 2
      @plays = params[:plays] # history of moves in form of array
    end

  end

end

# so let's get ready to play ... Tic Tac Toe!!
TicTacToe.main
