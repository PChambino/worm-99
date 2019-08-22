#!/usr/bin/env bundle exec ruby -Ilib

require 'sequel'

DB = Sequel.connect("postgres://worm99:worm99@localhost:5432/worm99")
WORMS = DB[:worms]

fitnesses = DB[<<~SQL]
  SELECT worm, SUM(turn) FROM (
    SELECT id, value#>>'{Snakes, 0, Name}' AS worm, MAX(turn) AS turn
    FROM game_frames GROUP BY 1, 2
  ) x GROUP BY 1 ORDER BY 2
SQL

fitnesses.each do |fitness|
  WORMS.where(name: fitness[:worm]).update(fitness: fitness[:sum])
end
