module Putter
  class Watcher
    def self.watch(obj, options={})
      method_proxy = ClassProxy
      obj.send(:prepend, method_proxy)
    end
  end
end
