module Saving
    def save
        Dir.mkdir('saves') unless Dir.exist?('saves')
        puts "Name your game save: "
        file_name = gets.chomp.downcase
        puts "Continue saving? (y/n)"
        answer = gets.chomp.downcase
        if answer == 'y'
            file = File.open("saves/#{file_name}.yml", 'w')
            YAML.dump({
                :board_pieces => @pieces_arr,
                :turn => @turn
            }, file)
            file.close
            abort "The game has succesfully been saved to your local device"
        else
            self.turn
        end
    end

    def load
        puts "Saved Files: #{Dir.children('./saves').map { |file| file[0...-4]} }"
        puts ""
        puts "Please enter the game file you want to load: "
        file_name = gets.chomp.downcase
        file = YAML.load(File.read("saves/#{file_name}.yml"))
        pieces_arr = file[:board_pieces]
        @turn = file[:turn]
        File.delete("saves/#{file_name}.yml")
        @board = Board.new
        unpackage_save(pieces_arr)
        self.board.print_board
        self.switch_turn
        self.turn
    end

end