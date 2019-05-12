#!/usr/bin/env bundle exec shotgun -Ilib

require 'sinatra'

get '/' do
  <<~TXT
  Home of Worm 99

  https://battlesnake.io
  TXT
end

post '/battle/ping' do
  'pong'
end

post '/battle/start' do
  {
    color: '#736CCB',
    headType: 'sand-worm',
    tailType: 'freckled'
  }.to_json
end

post '/battle/move' do
  { move: random_move }.to_json
end

post '/battle/end' do
  'done'
end

MOVES = %w[up down left right].freeze

def random_move
  MOVES.sample
end
