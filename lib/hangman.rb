# Simple hangman game
# Functional, needs review / refactoring
# Add hanging man graphic that updates for wrong guesses (based on @turns)

class Hangman

  def self.main
    @player = Player.new
    puts "Enter name"
    @player.name = gets.chomp
    puts "Play Hangman, #{@player.name}!"
    game
  end


  private

  def self.game
    @word = get_word
    @board = @word.map { |letter| letter = "_" }
    @turns = 6
    while @turns > 0
      graphic
      puts "\nGuess a letter or the word!"
      unless check_word(gets.chomp)
        unless @turns == 0
          puts "\n#{@turns} turns left!"
        else
          puts "\nNo turns left! You lost!"
          puts @word.join(" ")
          exit
        end
      else
        puts "\nYou won! Thanks for playing, #{@player.name}!"
        puts @word.join(" ")
        exit
      end
    end
  end

  def self.get_word
    File.readlines("5desk.txt").sample.chomp.split("")
  end

  def self.check_word(guess)
    match = 0
    @board.each_with_index { |space, index|
      if @word[index] == guess
        @board[index] = guess
        match += 1
      end
    }
    @turns -= 1 unless match > 0
    (@board == @word || @word.join == guess) ? true : false
  end

  def self.graphic
    puts @board.join(" ")
  end

  class Player
    attr_accessor :name
  end

end

Hangman.main
