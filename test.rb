#!/usr/bin/env bundle exec ruby -Ilib -Itest

require 'minitest'
require 'minitest/mock'
require 'minitest/pride'
Minitest.autorun

args = ARGV.empty? ? Dir['test/**/*_test.rb'] : ARGV
args.each do |arg|
  require_relative arg unless arg.start_with? '-'
end
