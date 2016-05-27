require "putter/follower"
require "putter/method_proxy"
require "putter/print_strategy"
require "putter/version"

module Putter
  def self.follow(obj, options={})
    Putter::Follower.new(obj, options)
  end
end
