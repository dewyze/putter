module Errors
  class BasicObjectError < StandardError
    def initialize(msg="Cannot follow instances of BasicObject")
      super
    end
  end
end
