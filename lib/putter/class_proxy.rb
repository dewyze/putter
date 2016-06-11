module Putter
  module ClassProxy
    STACK_TRACE_IGNORE_REGEX = /(?!.*(\.rbenv|\.rvm|putter\/lib\/putter\/follower))(^.*$)/
    def self.prepended(kls)
      methods = kls.methods - Object.methods

      ClassMethods.add_putter_class_method(kls)

      class << kls
        prepend ClassMethods
      end
    end

    module ClassMethods
      extend MethodCreator

      @@putter_followed_instances = []

      def new(*args, &blk)
        result = super *args, &blk
        @@putter_followed_instances << result
        ::Putter.follow(result, label: "#{name} instance #{@@putter_followed_instances.count}")
      end

      def self.add_putter_class_method(klass)
        (klass.methods - Object.methods).each do |method|
          data = ProxyMethodData.new(method, "label")
          add_putter_method_to_proxy(self, :module_exec, data)
        end
      end
    end
  end
end
