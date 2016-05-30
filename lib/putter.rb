require "putter/configuration"
require "putter/errors"
require "putter/follower"
require "putter/method_proxy"
require "putter/print_strategy"
require "putter/version"

module Putter
  include Errors

  class << self
    attr_writer :configuration
  end

  def self.follow(obj, options={})
    Putter::Follower.new(obj, options)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end
end
