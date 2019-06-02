#!/usr/bin/env bundle exec shotgun -Ilib

require 'sinatra'
require 'field'
require 'worm'

get '/' do
  <<~TXT
  Home of Worm 99

  https://battlesnake.io
  TXT
end

post '/ping' do
  'pong'
end

post '/start' do
  { color: random_colour, headType: HEADS.sample, tailType: TAILS.sample }.to_json
end

post '/move' do
  data = JSON.parse request.body.read, symbolize_names: true
  field = Field.new data
  worm = Worm.new
  moves = worm.moves_relative_to field.orientation
  move = moves.sample
  { move: move }.to_json
end

post '/end' do
  'done'
end

def random_colour
  Random.new.bytes(3).unpack("H*").first
end

HEADS = %w[beluga bendr dead evil fang pixel regular safe sand-worm shades silly smile tongue]
TAILS = %w[block-bum bolt curled fat-rattle freckled hook pixel regular round-bum sharp skinny small-rattle]
