module Errors
  class BasicObjectError < StandardError
    def initialize(msg="Cannot follow instances of BasicObject")
      super
    end
  end

  class MethodConflictError < StandardError
    def initialize(msg="Methods cannot be allow and denylisted")
      super
    end
  end
end
