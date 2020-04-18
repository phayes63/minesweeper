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

    def [](row, col)
        @grid[row][col]
    end

    def bomb_count(row, col)
        count = 0
        count += 1 if self.valid_right_of_tile(row, col)
        count += 1 if self.valid_left_of_tile(row, col)
        count += 1 if self.valid_above_tile(row, col)
        count += 1 if self.valid_below_tile(row, col)
        count += 1 if self.valid_down_right_of_tile(row, col)
        count += 1 if self.valid_down_left_of_tile(row, col)
        count += 1 if self.valid_up_right_of_tile(row, col)
        count += 1 if self.valid_up_left_of_tile(row, col)
        return count if count > 0
    end

    def valid_right_of_tile(row, col)
        @grid[row][col + 1].is_bomb && @grid[row][col + 1] != nil && col != 8
    end

    def valid_left_of_tile(row, col)
        @grid[row][col - 1].is_bomb && @grid[row][col - 1] != nil && col != 0
    end

    def valid_above_tile(row, col)
        @grid[row + 1][col].is_bomb && @grid[row + 1][col] != nil && row != 8
    end

    def valid_below_tile(row, col)
        @grid[row - 1][col].is_bomb && @grid[row - 1][col] != nil && row != 0
    end

    def valid_down_right_of_tile(row, col)
        @grid[row + 1][col + 1].is_bomb && @grid[row + 1][col + 1] != nil && (row != 8 && col != 8)
    end

    def valid_down_left_of_tile(row, col)
        @grid[row + 1][col - 1].is_bomb && @grid[row + 1][col - 1] != nil && (row != 8 && col != 0)
    end

    def valid_up_right_of_tile(row, col)
        @grid[row - 1][col + 1].is_bomb && @grid[row - 1][col + 1] != nil && (row != 0 && col != 8)
    end

    def valid_up_left_of_tile(row, col)
        @grid[row - 1][col - 1].is_bomb && @grid[row - 1][col - 1] != nil && (row != 0 && col != 0)
    end

    # STILL WORKING ON FIGURING THIS OUT...
    # def reveal(row, col)
    #     next_row = row + 1
    #     prev_row = row - 1
    #     next_col = col + 1
    #     prev_col = col - 1
    #     self[row, col].reveal

    #     if self.bomb_count(next_row, col) > 0 && next_row != 8 && self[next_row, col]
    #         self[next_row, col].proximity(bomb_count(next_row, col))
    #     else
    #         self[next_row, col].reveal
    #         self.reveal(next_row, col)
    #     end
    # end

end

if $PROGRAM_NAME == __FILE__
    b = Board.new
    b.render
    # b.reveal
    # b.render
    b.reveal(1, 4)
    # puts b.bomb_count(0, 5)
    # puts b.bomb_count(3, 3)
    # puts b.bomb_count(5, 3)   
    # puts b.bomb_count(7, 6)
    b.render
end