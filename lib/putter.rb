require "putter/version"
require "putter/instance_watcher"
require "putter/method_proxy"
require "putter/watcher_proxy"

module Putter
  def self.debug(object)
    watcher_proxy = WatcherProxy.get_watcher(object)
    watcher_proxy.new(object)
  end
end
