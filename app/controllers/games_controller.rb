require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @grid = params[:grid].split
    @attempt = params[:word]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @output = run_game(@attempt, @grid, @start_time, @end_time)
  end
end

private

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  api_serialized = open(url).read
  api = JSON.parse(api_serialized)

  if api["found"] == true
    if check_grid(attempt, grid) == false
      score_total = 50 * (attempt.length / (end_time - start_time))
      return { score: score_total, time: end_time - start_time, message: "Well done, you're a genious." }
    else
      return { score: 0, time: end_time - start_time, message: "Not in the grid" }
    end
  else
    return { score: 0, time: end_time - start_time, message: "That is not an english word" }
  end
end

def check_grid(attempt, grid)
  original_size = grid.length
  attempt.upcase.each_char do |char|
    grid.delete_at(grid.index(char)) if grid.include?(char)
  end
  if original_size - attempt.length < grid.length
    return true
  else
    return false
  end
end
