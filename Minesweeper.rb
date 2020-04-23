require_relative "board"

class Minesweeper

    ALPHA = ("a".."z").to_a + ("A".."Z").to_a

    attr_reader :board

    def initialize(board = Board.new)
        @board = board
    end

    def instructions
        puts ""
        puts "So, this is Minesweeper. You may have played this one"
        puts "back in the day. To play, you'll select a space on the board"
        puts "that you think (really, hope) is empty. If you're right and -"
        puts "fingers crossed! - it is empty, then you'll be shown some"
        puts "more empty spaces, as well as some spaces with numbers."
        puts "Those numbers tell you how many bombs are adjenct (aka next"
        puts "to) that spot. The bomb could be up, down, left, right, or" 
        puts "on any diagonal. That's a lot to think about, so you better"
        puts "get to it!"
        puts ""
        puts "Select your space - be careful, avoid those mines. Enter"
        puts "the row number followed by the column number with a comma in"
        puts "between, for example 2,4. Notice the grid ranges from 0 to 8"
        puts "for both rows and columns, so keep your guess for each in" 
        puts "that range."
    end

    def play
        self.instructions
        until @board.game_over?
            @board.render
            puts ""
            print "Time to roll the dice. Enter your guess (for example 2,4): "
            guess = gets.chomp.split(",")
            if guess.length == 3 && (guess[2] == "f" || guess[2] == "F")
                if self.is_valid_guess?(guess[0...2])
                    p1, p2, flag = Integer(guess[0]), Integer(guess[1]), guess[2]
                    @board[p1, p2].flag
                end
            elsif guess.length == 2
                if self.is_valid_guess?(guess) 
                    @board.reveal(Integer(guess[0]), Integer(guess[1]))
                end
            else
                self.invalid_message
            end
            File.open("sweep.yml", "w") { |file| file.write(@board.to_yaml) }
        end
        @board.reveal_all
        @board.render
        puts ["You've been blown to smithereens!", "They're still looking for pieces of you in the bushes!", "You're red mist"].sample(1) if @board.lose?
        puts "Nicely done, cleared it!" if !@board.lose?
        puts "Wow, that was exciting to watch, but I imagine it was"
        puts "stress-inducing to play! But hey, a little stress can be good for"
        puts "the soul (I don't know, I made that up). Either way, you up for"
        puts "another game? Type y or n (keep em lowercase), then press enter."
        play_again = gets.chomp
        if play_again == "y"
            puts "Heck yeah ya do! Let's roll..."
            puts ""
            sweep = Minesweeper.new
            sweep.play
        else
            puts "No worries, totally get it. Sweeping for mines is a high-stress gig."
            puts "Take a break. Maybe eat some pizza or binge watch Netflix. Take the dog"
            puts "for a walk. I dunno, you do you, thanks for hanging for a bit!"
        end
    end

    def invalid_message
        puts ""
        puts "Hmmm something went wrong there. Did you stay in range and use a comma? Try again..."
        puts ""
    end

    def is_valid_guess?(guess)
        x, y = guess
        if ALPHA.include?(x) || ALPHA.include?(y)
            self.invalid_message
            return false
        end
        if (0..8).to_a.include?(Integer(x)) && (0..8).to_a.include?(Integer(y)) && guess.length == 2
            return true
        else
            self.invalid_message
            return false
        end
    end

    # JUST FOR TESTING WINS
    # def locate
    #     bombs = []
    #     @board.grid.each_with_index do |row, i_1|
    #         row.each_with_index { |col, i_2| bombs << [i_1, i_2] if col.is_bomb }
    #     end
    #     print bombs
    # end
    def run
        print "New game or picking up from earlier? Enter new or return: "
        response = gets.chomp
        if response == "new"
            sweep = Minesweeper.new
            File.open("sweep.yml", "w") { |file| file.write(@board.to_yaml) }
            while !self.board.game_over?
            save = board_from_yaml_file = YAML.load(File.read("sweep.yml"))
            self.play
            end
        end 
        if response == "return"
            board = YAML.load(File.read("sweep.yml"))
            pickup = Minesweeper.new(board)
            pickup.play
        end
    end

end

sweep = Minesweeper.new
sweep.run