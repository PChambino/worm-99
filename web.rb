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
  'pong'
end

post '/battle/move' do
  'pong'
end

post '/battle/end' do
  'pong'
end
