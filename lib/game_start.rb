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
end