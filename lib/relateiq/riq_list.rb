module RelateIQ
  class RiqList
    include Enumerable

    attr_accessor :list

    def initialize(list)
      @list = list
    end

    def <<(val)
        @list << val
    end

    def each(&block)
        @list.each(&block)
    end

  end
end
