require "colorize"

class Tile

    def initialize(is_bomb, start_symbol)
        @start_symbol = start_symbol
        @face = start_symbol
        @is_bomb = is_bomb
        @flagged = [false, true]
        @revealed = false
    end

    def reveal
        @revealed = true
        @is_bomb == false ? @face = "_" : @face = "!"
    end

    def flag
        @flagged.rotate!
        @flagged[0] == true ? @face = "F" : @start_symbol
    end 

    def proximity
        @face = (1..8).to_a
        # Not sure about this yet...
    end

end