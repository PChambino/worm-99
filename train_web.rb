#!/usr/bin/env bundle exec ruby -Ilib

require 'pry'
require 'sequel'
require 'faraday'

require 'worm'

seed = ARGV[0]&.to_i || Random.new_seed
srand seed
puts 'seed', seed

DB = Sequel.connect("postgres://worm99:worm99@localhost:5432/worm99")

DB.create_table :worms do
  String :name, primary_key: true
  jsonb :brain
  Integer :fitness
end unless DB.table_exists? :worms

WORMS = DB[:worms]

worms =
  if WORMS.limit(1).count.zero?
    1000.times
      .map { |index| Worm.new name: "worm-gen0-#{index}" }
      .each { |worm| WORMS.insert name: worm.name, brain: worm.brain.dump.to_json }
  else
    WORMS.map do |worm|
      worm[:brain] = Brain.new(inputs: 3, outputs: 3)
        .load! JSON.parse worm[:brain]

      Worm.new worm
    end
  end

Engine = Faraday.new url: 'http://localhost:3005'

game_ids = worms.map do |worm|
  sleep 0.5

  5.times.map do
    res = Engine.post '/games' do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        width: 8,
        height: 8,
        food: 2,
        snakes: [{ name: worm.name, url: 'http://localhost:9393' }]
      }.to_json
    end

    JSON.parse(res.body)
      .yield_self { |res| res["ID"] }
      .tap { |game_id| Engine.post "/games/#{game_id}/start" }
  end
end

puts "waiting for games to finish..."
gets

fitnesses = DB[<<~SQL, game_ids]
  SELECT worm, SUM(turn) FROM (
    SELECT id, value#>>'{Snakes, 0, Name}' AS worm, MAX(turn) AS turn
    FROM game_frames WHERE id IN ? GROUP BY 1, 2
  ) x GROUP BY 1 ORDER BY 2
SQL

fitnesses.each do |fitness|
  WORMS.where(name: fitness[:worm]).update(fitness: fitness[:sum])
end

# select worm, SUM(turn), ARRAY_AGG(turn) FROM (select id, value#>>'{Snakes, 0, Name}' as worm, MAX(turn) as turn from game_frames group by 1, 2) x group by 1 order by 2;
