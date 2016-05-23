module Putter
  module DebuggerProxy
    def self.get_debugger(object)
      if object.class != Class && object.class != Module
        return InstanceDebugger
      end
    end
  end
end
