require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    @letters = []
    @start_time = Time.now.sec
    10.times do
      @letters << alphabet.sample
    end
    return @letters
  end

  def score
    @letters = params[:letters].split('')
    @word = params[:word]
    @start_time = params[:start_time]
    @end_time = Time.now.sec
    @result = run_game(@word, @letters, @start_time, @end_time)
  end

  def run_game(attempt, letters, start_time, end_time)
    score = 0
    if existing_word?(attempt) == 'false'
      message = "#{attempt} is not an english word."
    elsif !compare_grid_attempt(attempt, letters)
      message = "Your letters are not in the grid/letters overuse."
    else
      message = "Well done!"
      score = (attempt.length * 100) - (end_time.to_i - start_time.to_i)
    end
    { message: message, score: score }
  end

  # Checks if the word exists or not
  def existing_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

  def compare_grid_attempt(attempt, letters)
    attempt.chars.all? { |letter| attempt.count(letter) <= letters.count(letter) }
  end
end
