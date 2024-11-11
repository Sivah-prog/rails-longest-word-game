class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @valid_word = valid_word?(@word, @letters)
    @is_english_word = english_word?(@word)

    if !@valid_word
      @result = "Sorry, but #{@word} can't be built out of #{@letters.join(", ")}"
    elsif !@is_english_word
      @result = "Sorry, but #{@word} is not an English word"
    else
      @result = "Congratulations! #{@word} is a valid English word"
      session[:score] = (session[:score] || 0) + @word.length
    end
  end

  private

  def valid_word?(word, letters)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
