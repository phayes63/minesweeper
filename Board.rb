require_relative "tile"

class Board

    attr_reader :grid, :make_pairs

    def initialize
        @grid = Array.new(9) {Array.new(9)}
        (0..8).each do |tile|
            @grid.each { |row| row[tile] = Tile.new(false, "*")} 
       end
       self.make_pairs
       self.plant_bombs
    end

    def make_pairs
        bomb_pairs = []
        until bomb_pairs.length == 10
            sample = (0..8).to_a.sample(2)
            bomb_pairs << sample if !bomb_pairs.include?(sample)
        end
        bomb_pairs
    end

    def plant_bombs
        self.make_pairs.each do |bomb|
            x, y = bomb
            @grid[x][y].make_bomb
        end
    end

    def render
        puts ""
        puts "Minesweeper".center(20)
        puts ""
        puts "-" * 20
        puts @grid.map { |row| row.map { |tile| tile.face.rjust(2) }.join }
        puts "-" * 20
    end

    def reveal
        @grid.each do |row|
            row.each { |tile| tile.reveal }
        end
    end

end