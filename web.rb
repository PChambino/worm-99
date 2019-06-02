#!/usr/bin/env bundle exec shotgun -Ilib

require 'sinatra'
require 'field'
require 'worm'

WORM = Worm.new brain: Brain.new(inputs: 3, outputs: 3).load! [
  0.31671052931654775, 0.5307057940571163, 0.6222012759131952, 0.7531315216866732, 0.1986249920565537, 0.9927828675206156, 0.9737619138500143, 0.9950224210075828, 0.29391318040821657
]

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
  move = WORM.move field
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
