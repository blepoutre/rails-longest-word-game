require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = []
    letter_count = Hash.new(0)
    until @letters.size == 10
      letter = ('A'..'Z').to_a.sample
      if letter_count[letter] < 2
        @letters << letter
      else
        letter_count[letter] += 1
      end
    end
  end

  def score
    @letters = params[:letters].split
    word_play = params[:play].upcase

    if word_in_grid?(word_play, @letters)
      url = "https://dictionary.lewagon.com/#{params[:play]}"
      user_serialized = URI.open(url).read
      @user = JSON.parse(user_serialized)
      if @user['found']
        @response = "Congratulations! #{word_play} is a valid English word!"
      else
        @response = "Sorry, but #{word_play} is not a valid English word."
      end
    else
      @response = "Sorry, but #{word_play} can't be built out of #{@letters.join(', ')}."
    end
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end
