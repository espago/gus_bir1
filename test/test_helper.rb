# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gus_bir1'
require 'minitest/autorun'
