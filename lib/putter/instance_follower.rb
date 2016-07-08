module Putter
  module InstanceFollower
    @@putter_followed_instances = []

    def new(*args, &blk)
      result = super *args, &blk
      @@putter_followed_instances << result
      ::Putter.follow(result, label: "#{name} instance #{@@putter_followed_instances.count}")
    end
  end
end
