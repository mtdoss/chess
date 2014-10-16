require 'colorize'
# require_relative 'game'

# def initialize(fill_board = false)
  grid = Array.new(8) { Array.new(8) }
  grid.flatten.each_with_index do |square, idx|
    square = "  "
    square.colorize(:background => :white) if idx.even?
    square.colorize(:background => :gray) if idx.odd?
  end
# end

p grid