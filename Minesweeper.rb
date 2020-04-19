require_relative "board"

class Minesweeper

    def initialize
        board = Board.new
    end

    def instructions
        board.render
        puts ""
        puts "So, this is Minesweeper. You may have played this one back in the day. To play,"\
        " you'll select a space on the board that you think (really, hope) is empty. If you're"\
        " right - fingers crossed! - then you'll be shown some more empty space, as well as"\
        " some spaces with numbers. Those numbers tell you how many bombs are adjenct (aka next"\
        " to) that spot. The bomb could be up, down, left, right, or on any diagonal. That's a"\
        " lot to think about, so you better get to it!"
        puts ""
        puts "Select your space - be careful, avoid those mines. Enter the row number followed"\
        " by the column number with a comma in between, for example 2, 4. Notice the grid ranges"\
        " from 0 to 8 for bott rhows and columns, so keep you guess for each in that range."
    end

    def play
        self.instructions
        until board.game_over?
            puts "Time to roll the dice. Enter your guess (for example 2, 4): "
            guess = gets.chomp.split(",")
                "Hmmm something went wrong there. Did you stay in range and use a comma? Try again..."
            if self.is_valid_guess(guess) 
                board.reveal(guess[0], guess[1]) if self.is_valid_guess(guess)
                board.render
            else
                puts "Hmmm something went wrong there. Did you stay in range and use a comma? Try again..."
                puts ""
            end
        end
        puts "Wow, that was exciting to watch, but I imagine it was stress-inducing to play! But hey, a"\
        " little stress can be good for the soul (I don't know, I made that up). Either way, you up for"\
        " another game? Type y or n (keep em lowercase), then press enter."
        play_again = gets.chomp
        if play_again == "y"
            puts "Heck yeah ya do! Let roll..."
            puts ""
            self.play
        else
            puts "No worries, totally get it. Sweeping for mines is high-stress gig. Take a break. Maybe eat"\
            "some pizza or binge watch Netflix. You do you, thanks for hanging for a bit!"
        end
    end

    def is_valid_guess(guess)
        x, y = guess
        ((0..8).to_a.include?(x) && (0..8).to_a.include?(y)) && guess.length == 2
    end

end

if $PROGRAM_NAME == __FILE__
    sweep = Minesweeper.new
    sweep.play
end