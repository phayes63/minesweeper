require "colorize"

class Tile

    attr_reader :face, :is_bomb, :revealed

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

    def proximity(bomb_count)
        @face = bomb_count.to_s if @revealed == false
    end

    def make_bomb
        @is_bomb = true
    end

end