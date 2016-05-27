require "putter/follower"
require "putter/method_proxy"
require "putter/print_strategy"
require "putter/version"

module Putter
  def self.follow(obj)
    Putter::Follower.new(obj)
  end
end
