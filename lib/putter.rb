require "putter/version"
require "putter/instance_debugger"
require "putter/method_proxy"
require "putter/debugger_proxy"

module Putter
  def self.debug(object)
    debugger_proxy = DebuggerProxy.get_debugger(object)
    debugger_proxy.new(object)
  end
end
