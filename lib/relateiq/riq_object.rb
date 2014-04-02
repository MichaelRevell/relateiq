module RelateIQ
  class RiqObject
    include Enumerable

    attr_accessor :api_key, :values
    @@permanent_attributes = Set.new([:id])

    def initialize(id=nil, api_key=nil)
      # parameter overloading!
      if id.kind_of?(Hash)
        @retrieve_options = id.dup
        @retrieve_options.delete(:id)
        id = id[:id]
      else
        @retrieve_options = {}
      end

      @api_key = api_key
      @values = {}
      # This really belongs in APIResource, but not putting it there allows us
      # to have a unified inspect method
      @unsaved_values = Set.new
      @transient_values = Set.new
      @values[:id] = id if id
    end

    def refresh_from(values)

      @previous_metadata = values[:metadata]
      removed = Set.new(@values.keys - values.keys)
      added = Set.new(values.keys - @values.keys)
      # Wipe old state before setting new.  This is useful for e.g. updating a
      # customer, where there is no persistent card parameter.  Mark those values
      # which don't persist as transient

      instance_eval do
        add_accessors(added)
      end
      values.each do |k, v|
        @values[k.to_sym] = v
      end
      self
    end

    def self.construct_from(values, api_key=nil)
      obj = self.new(values[:id], api_key)
      obj.refresh_from(values, api_key)
      obj
    end

    def inspect()
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@values)
    end

    def metaclass
      class << self; self; end
    end

    def add_accessors(keys)
      metaclass.instance_eval do
        keys.each do |k|
          next if @@permanent_attributes.include?(k)
          k_eq = :"#{k}="
          #define_method(k) { @values[k] }
          define_method(k_eq) do |v|
            if v == ""
              raise ArgumentError.new(
                "You cannot set #{k} to an empty string." +
                "We interpret empty strings as nil in requests." +
                "You may set #{self}.#{k} = nil to delete the property.")
            end
            @values[k.to_sym] = v
          end
        end
      end
    end

    def method_missing(name, *args)
      # TODO: only allow setting in updateable classes.
      if name.to_s.end_with?('=')
        attr = name.to_s[0...-1].to_sym
        # Set the value if it's not a permanent attribute
        if @@permanent_attributes.include?(k)
          raise NoMethodError.new("Cannot set #{attr} on this object. HINT: you can't set: #{@@permanent_attributes.to_a.join(', ')}")
        else
          add_accessors([attr])
        end
      else
        return @values[name]
      end

      begin
        # Let's not get all crazy now
        nil
        #super
      rescue NoMethodError => e
        if @transient_values.include?(name)
          raise NoMethodError.new(e.message + ".  HINT: The '#{name}' attribute was set in the past, however.  It was then wiped when refreshing the object with the result returned by Stripe's API, probably as a result of a save().  The attributes currently available on this object are: #{@values.keys.join(', ')}")
        else
          raise
        end
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      @values.has_key?(symbol.to_sym) || nil
    end
  end
end
