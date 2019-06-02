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
  {
    color: '#736CCB',
    headType: 'sand-worm',
    tailType: 'freckled'
  }.to_json
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
