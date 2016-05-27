$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../support', __FILE__)

require "pry"
require "putter"
require "test_class"

module Putter
  module PrintStrategy
    Testing = Proc.new {}
  end
end
