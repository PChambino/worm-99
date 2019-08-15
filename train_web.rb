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
    10.times
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

10.times do
worms.each do |worm|
  res = Engine.post '/games' do |req|
    req.headers['Content-Type'] = 'application/json'
    req.body = {
      width: 4,
      height: 4,
      food: 2,
      snakes: [{ name: worm.name, url: 'http://localhost:9393' }]
    }.to_json
  end

  game_id = JSON.parse(res.body)
    .yield_self { |res| res["ID"] }

  Engine.post "/games/#{game_id}/start"
end
end

# select worm, SUM(turn::int), ARRAY_AGG(turn) FROM (select id, value#>>'{Snakes, 0, Name}' as worm, MAX(value->>'Turn')as turn from game_frames group by 1, 2 order by 2,3) x group by 1 order by 2;
