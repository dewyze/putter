require "putter/configuration"
require "putter/errors"
require "putter/follower_data"
require "putter/instance_follower"
require "putter/method_creator"
require "putter/method_proxy"
require "putter/print_strategy"
require "putter/proxy_method_data"
require "putter/version"
require "putter/watcher_data"

require "putter/follower"
require "putter/watcher"

module Putter
  include Errors

  class << self
    attr_writer :configuration

    def follow(obj, options={})
      Putter::Follower.new(obj, options)
    end

    def watch(obj, options={})
      Putter::Watcher.watch(obj, options)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def reset_configuration
      @configuration = Configuration.new
    end
  end
end
