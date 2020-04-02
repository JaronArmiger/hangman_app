require 'game_start'
require 'game_player'

class HangmanApp < Sinatra::Base
	set :root, 'lib/app'
	enable :sessions

	configure :development do
		register Sinatra::Reloader
	end

	not_found do
		erb :error, layout: true
	end

	get '/' do
		erb :index, {layout: true}
	end

	get '/start' do
		new_or_load = params['new_or_load?']
		if new_or_load == 'new'
			game = Game.new
			print "game"; p game
		else
			#functionality for loading game
		end
		start_session(game)
		erb :start
	end

	get '/play' do
		#print "session"; p session
		@display = session[:display]
		@misses = session[:misses]
		@message = session.delete(:message)
		erb :play
	end

	post '/play' do
		print "word "; p session[:word]
		@word = session[:word]
		display = session[:display]
		guess = params['letter']
		print "guess "; p guess
		if valid?(guess)
			unless already_guessed?(guess)
				game_player = GamePlayer.new
				indices = game_player.check_letter(@word,guess)
				if indices.empty?
					session[:incorrect_guesses] += 1
					print "incorrect "; p session[:incorrect_guesses]
					session[:misses][session[:incorrect_guesses] - 1] = guess
				end
				session[:round_number] += 1
				session[:display] = game_player.update_display(@word, indices, display)
				#session[:misses] = misses
				@display = session[:display]
			end
		end

		if session[:misses].length == 6
			@result_message = "You lose :( Ya mans was hanged"
			erb :end
		elsif session[:display] == @word
			@result_message = "YOU WIN!"
			erb :end
		else #continue playing
			redirect '/play'
		end
		#print "session "; p session
	end

	def start_session(game)
		session[:word] = game.word
		session[:incorrect_guesses] = game.incorrect_guesses
		session[:display] = game.display
		session[:misses] = game.misses
		session[:round_number] = game.round_number
	end

	def valid?(input)
		if input.length == 1
			return true
		elsif input.length == 0
			session[:message] = "Enter a letter dude"
		else
			session[:message] = "You can only enter 1 letter!"
		end
		false
	end

	def already_guessed?(guess)
		if session[:display].include?(guess) || session[:misses].include?(guess)
			session[:message] = "You already guessed #{guess}! Choose a different letter!"
			return true
		end
		false
	end
end