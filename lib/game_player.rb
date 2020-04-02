class GamePlayer
	def update_display(word, indices, display)
		indices.each do |i|
			display[i] = word[i]
		end
		display
	end

	def check_letter(word,letter)
		indices = (0...word.length).find_all { |i| word[i] == letter }
	end

	def round
		@guess = get_guess
		indices = check_letter(@word,@guess)
		update_display(@word,indices)
		show_console
		@round_number += 1
	end

	def play
		while @misses.length < 6
			round
			break if save?
			if @display == @word
				puts "you win!"
				break
			end
		end
		puts "you lose :(" if @misses.length == 6
	end
end