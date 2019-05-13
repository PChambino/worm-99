#!/usr/bin/env bundle exec ruby -Ilib -Itest

require 'minitest'
require 'minitest/mock'
require 'minitest/pride'
Minitest.autorun

files = ARGV.select { |arg| File.exists? arg }
files = Dir['test/**/*_test.rb'] if files.empty?
files.each { |file| require_relative file }
