#!/usr/bin/env bundle exec shotgun -Ilib

require 'sinatra'
require 'sequel'

require 'field'
require 'worm'

DB = Sequel.connect("postgres://worm99:worm99@localhost:5432/worm99")
WORMS = DB[:worms]

WORM = Worm.new(
  name: 'worm99',
  brain: Brain.new(inputs: 3, outputs: 3).load!([
    0.31671052931654775, 0.5307057940571163, 0.6222012759131952,
    0.7531315216866732, 0.1986249920565537, 0.9927828675206156,
    0.9737619138500143, 0.9950224210075828, 0.29391318040821657
  ])
)

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
  name = data.dig(:you, :name)

  worm = WORM if name == 'worm99'
  worm ||= WORMS[name: name]
    .yield_self do |worm|
      worm[:brain] = Brain.new(inputs: 3, outputs: 3)
        .load! JSON.parse worm[:brain]

      Worm.new worm
    end

  field = Field.new data
  move = worm.move field
  { move: move }.to_json
end

post '/end' do
  'done'
end

def random_colour
  "##{Random.new.bytes(3).unpack("H*").first}"
end

HEADS = %w[beluga bendr dead evil fang pixel regular safe sand-worm shades silly smile tongue]
TAILS = %w[block-bum bolt curled fat-rattle freckled hook pixel regular round-bum sharp skinny small-rattle]
