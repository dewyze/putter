require "putter/version"
require "putter/instance_watcher"
require "putter/method_proxy"

module Putter
  def self.debug(object)
    InstanceWatcher.new(object)
  end
end
