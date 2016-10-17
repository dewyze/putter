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
      with_production_check do
        Putter::Follower.new(obj, options)
      end
    end

    def watch(obj, options={})
      with_production_check do
        Putter::Watcher.watch(obj, options)
      end
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

    def with_production_check
      if !configuration.allow_production && defined?(Rails) && Rails.env == "production"
        puts "Putter cannot be run in production unless the 'allow_production' option is configured to true".colorize(:red)
      else
        yield
      end
    end
  end
end
