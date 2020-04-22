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
        puts "Minesweeper".center(20).colorize(:blue)
        puts "-" * 20
        puts "  0 1 2 3 4 5 6 7 8"
        i = 0
        @grid.each do |row|
            print i
            (0..8).each do |row_idx|
                print row[row_idx].face.rjust(2)
            end
            puts "\n"
            i += 1
        end
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
        return count
    end

    def valid_right_of_tile(row, col)
        return false if col == 8
        @grid[row][col + 1].is_bomb && @grid[row][col + 1] != nil
    end

    def valid_left_of_tile(row, col)
        return false if col == 0
        @grid[row][col - 1].is_bomb && @grid[row][col - 1] != nil
    end

    def valid_above_tile(row, col)
        return false if row == 8
        @grid[row + 1][col].is_bomb && @grid[row + 1][col] != nil
    end

    def valid_below_tile(row, col)
        return false if row == 0
        @grid[row - 1][col].is_bomb && @grid[row - 1][col] != nil
    end

    def valid_down_right_of_tile(row, col)
        return false if row == 8 || col == 8
        @grid[row + 1][col + 1].is_bomb && @grid[row + 1][col + 1] != nil
    end

    def valid_down_left_of_tile(row, col)
        return false if row == 8 || col == 0
        @grid[row + 1][col - 1].is_bomb && @grid[row + 1][col - 1] != nil
    end

    def valid_up_right_of_tile(row, col)
        return false if row == 0 || col == 8
        @grid[row - 1][col + 1].is_bomb && @grid[row - 1][col + 1] != nil
    end

    def valid_up_left_of_tile(row, col)
        return false if row == 0 || col == 0
        @grid[row - 1][col - 1].is_bomb && @grid[row - 1][col - 1] != nil
    end

    def reveal(row, col)
        self[row, col].reveal
        search_row(row, col)
        search_col(row, col)
        search_diagonal(row, col)
    end

    def search_row(row, col)
        (row+1...8).each do |next_row|
            break if row == 8 || self[next_row, col].is_bomb
            if bomb_count(next_row, col) > 0
                self[next_row, col].proximity(bomb_count(next_row, col))
                break
            else
                self[next_row, col].reveal if self[next_row, col].is_bomb == false
                self.search_col(next_row, col) if self[next_row, col].is_bomb == false
                self.search_diagonal(next_row, col) if self[next_row, col].is_bomb == false
            end
        end
        (0...row).to_a.reverse.each do |last_row|
            break if row == 0 || self[last_row, col].is_bomb
            if bomb_count(last_row, col) > 0
                self[last_row, col].proximity(bomb_count(last_row, col))
                break
            else
                self[last_row, col].reveal if self[last_row, col].is_bomb == false
                self.search_col(last_row, col) if self[last_row, col].is_bomb == false
                self.search_diagonal(last_row, col) if self[last_row, col].is_bomb == false
            end
        end
    end

    def search_col(row, col)
        (col+1...8).each do |next_col|
            break if col == 8 || self[row, next_col].is_bomb
            if bomb_count(row, next_col) > 0
                self[row, next_col].proximity(bomb_count(row, next_col))
                break
            else
                self[row, next_col].reveal if self[row, next_col].is_bomb == false
            end
        end
        (0...col).to_a.reverse.each do |last_col|
            break if col == 0 || self[row, last_col].is_bomb
            if bomb_count(row, last_col) > 0
                self[row, last_col].proximity(bomb_count(row, last_col))
                break
            else
                self[row, last_col].reveal if self[row, last_col].is_bomb == false
            end
        end
    end

    def search_diagonal(row, col)
        (row+1...8).each do |next_row|
            break if row == 8 || col == 8 || self[next_row, col + 1].is_bomb
            if bomb_count(next_row, col+1) > 0 && col != 8
                self[next_row, col+1].proximity(bomb_count(next_row, col+1))
                break
            else
                self[next_row, col+1].reveal if self[next_row, col+1].is_bomb == false
            end
        end
        (row+1...8).each do |next_row|
        break if row == 8 || col == 8 || self[next_row, col - 1].is_bomb
            if bomb_count(next_row, col-1) > 0 && col != 0
                self[next_row, col-1].proximity(bomb_count(next_row, col-1))
                break
            else
                self[next_row, col-1].reveal if self[next_row, col-1].is_bomb == false
            end
        end
        (0...row).to_a.reverse.each do |last_row|
            break if row == 8 || col == 8 || self[last_row, col + 1].is_bomb
            if bomb_count(last_row, col+1) > 0 && col != 8
                self[last_row, col+1].proximity(bomb_count(last_row, col+1))
                break
            else
                self[last_row, col+1].reveal if self[last_row, col+1].is_bomb == false
            end
        end
        (0...row).to_a.reverse.each do |last_row|
            break if row == 8 || col == 8 || self[last_row, col - 1].is_bomb
            if bomb_count(last_row, col-1) > 0 && col != 0
                self[last_row, col-1].proximity(bomb_count(last_row, col-1))
                break
            else
                self[last_row, col-1].reveal if self[last_row, col-1].is_bomb == false
            end
        end
    end

    def reveal_all
        @grid.each { |row| row.each { |tile| tile.reveal if tile.revealed == false } }  
    end

    def win?
        @grid.each do |row|
            row.each do |col|
                return false if !col.revealed && !col.is_bomb
            end
        end
        return true
    end

    def lose?
        @grid.any? { |row| row.any? { |tile| tile.is_bomb && tile.revealed }}
    end

    def game_over?
        self.win? || self.lose?
    end
end

# if $PROGRAM_NAME == __FILE__
#     b = Board.new
#     b.render
#     # b.reveal
#     # b.render
#     # puts b.bomb_count(1, 4)
#     # puts b.bomb_count(0, 5)
#     b.reveal(3, 3)
#     # puts b.bomb_count(5, 3)   
#     # puts b.bomb_count(7, 6)
#     b.render
#     b.reveal_all
#     b.render
# end