require 'json'

class Game
	attr_accessor :word, :incorrect_guesses, :display, :misses, :round_number
	def initialize
		@incorrect_guesses = 0
		@word = generate_word.downcase
		generate_display(@word)
		@misses = ''
		@round_number = 1
	end

	def generate_word
		contents = File.readlines "./lib/5desk.txt"
		words = []
		contents.each do |word|
			words.push(word) if word.length >= 5 && word.length <= 12
		end
		word = words[rand(words.length)]
		word.gsub!(/[^a-z]/, '')
	end
	
	def generate_display(word)
		@display = ""
		word.length.times do
				@display += "_"
		end
	end

	def update_display(word, indices, display)
		indices.each do |i|
			display[i] = word[i]
		end
		display
	end

	def get_guess
		puts "Guess a letter!"
		valid = false

		while !valid
			@guess = gets.chomp.downcase
			if @guess.match(/^[a-z]$/)
				valid = true
			else
				puts "type a single letter!"
			end
		end
		@guess
	end

	def check_letter(word,letter)
		indices = (0...word.length).find_all { |i| word[i] == letter }
		if indices.empty?
			@incorrect_guesses += 1
			@misses[@incorrect_guesses - 1] = letter
		end
		indices

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







	def to_json(*a)
		{		:word => @word,
				:incorrect_guesses => @incorrect_guesses,
				:display => @display,
				:misses => @misses,
				:round_number => @round_number
		}.to_json(*a)
	end

	def save
		puts "name your saved game"
		game_name = gets.chomp.downcase
		json_string = self.to_json
		Dir.mkdir('saved_games') unless Dir.exists? 'saved_games'
		filename = "saved_games/#{game_name}.json"

		File.open(filename, 'w') do |file|
			file.puts json_string
		end
	end

	def save?
		puts "save game? y/n"
		choice = gets.chomp.downcase
		if choice == 'y'
			save
			return true
		end
	end

	def load_game
		puts "saved games:"
		shortened_names = []
		Dir.glob('saved_games/*').each do |pathname|
			shortened = pathname.gsub('saved_games/', '').gsub('.json', '')
			shortened_names.push(shortened)
			puts "\t#{shortened}"
		end

		sleep(0.5)
		valid = false
		while !valid
			puts "which game ? your choice must match preexisting name"
			choice = gets.chomp.downcase
			shortened_names.each do |shortened_name|
				if choice == shortened_name
					game_name = "saved_games/#{shortened_name}.json"
					puts game_name
					contents = File.read(game_name)
					data = JSON.load contents
					@word = data['word']
					@incorrect_guesses = data['incorrect_guesses']
					@display = data['display']
					@misses = data['misses']
					@round_number = data['round_number']
					valid = true
				end
			end
		end
	end

	def load_game?
		valid = false
		while !valid
			puts "load game or new game?"
			choice = gets.chomp.downcase
			if choice == 'load game'
				return true
				valid = true
			elsif choice == 'new game'
				return false
				valid = true
			end
		end
	end
end


 