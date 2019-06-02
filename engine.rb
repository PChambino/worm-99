#!/usr/bin/env ruby

unless File.exist? 'engine/engine'
  puts <<~TXT
  Download latest release into engine directory:
  https://github.com/battlesnakeio/engine/releases
  TXT
  abort
end

engine_args = '-b sql -a "user=worm-99 sslmode=disable"' if ARGV.first == 'db'

spawn "engine/engine server #{engine_args}"
spawn 'ruby -run -e httpd engine/board -p 3009'
Process.wait
