require 'time'
require 'date'

module RDF; class Literal
  ##
  # A duration literal.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#duration
  class Duration < Literal
    DATATYPE = XSD.duration
    GRAMMAR  = %r(\A
      (?<si>-)?
      P(?:(?:(?:(?:(?<yr>\d+)Y)(?:(?<mo>\d+)M)?(?:(?<da>\d+)D)?)
          |  (?:(?:(?<mo>\d+)M)(?:(?<da>\d+)D)?)
          |  (?:(?<da>\d+)D)
          )
          (?:T(?:(?:(?:(?<hr>\d+)H)(?:(?<mi>\d+)M)?(?<se>\d+(?:\.\d+)?S)?)
              |  (?:(?:(?<mi>\d+)M)(?:(?<se>\d+(?:\.\d+)?)S)?)
              |  (?:(?<se>\d+(?:\.\d+)?)S)
              )
          )?
       |(?:T(?:(?:(?:(?<hr>\d+)H)(?:(?<mi>\d+)M)?(?<se>\d+(?:\.\d+)?S)?)
            |  (?:(?:(?<mi>\d+)M)(?:(?<se>\d+(?:\.\d+)?)S)?)
            |   (?:(?<se>\d+(?:\.\d+)?)S)
            )
        )
       )
    \z)x.freeze

    ##
    # * Given a Numeric, assumes that it is milliseconds
    # * Given a String, parse as xsd:duration
    # * Hash form is used for internal representation
    # @param  [Duration, Hash, Numeric, #to_s] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super
      @object   = case value
      when Hash
        value = value.dup
        value[:yr] ||= value[:years]
        value[:mo] ||= value[:months]
        value[:da] ||= value[:days]
        value[:hr] ||= value[:hours]
        value[:mi] ||= value[:minutes]
        value[:se] ||= value[:seconds]
        
        value
      when Duration, Numeric
        {:se => value.to_f}
      else
        parse(value.to_s)
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # Also normalizes elements
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema11-2/#dateTime
    def canonicalize!
      @string = @humanize = nil
      if @object[:se].to_i > 60
        m_r = (@object[:se].to_f / 60) - 1
        @object[:se] -=  m_r * 60
        @object[:mi] = @object[:mi].to_i + m_r
      end
      if @object[:mi].to_i > 60
        h_r = (@object[:mi].to_i / 60) - 1
        @object[:mi] -=  h_r * 60
        @object[:hr] = @object[:hr].to_i +  h_r
      end
      if @object[:hr].to_i > 24
        d_r = (@object[:hr].to_i / 24) - 1
        @object[:hr] -=  d_r * 24
        @object[:da] = @object[:da].to_i + d_r
      end
      if @object[:da].to_i > 30
        m_r = (@object[:da].to_i / 30) - 1
        @object[:da] -=  m_r * 30
        @object[:mo] = @object[:mo].to_i + m_r
      end
      if @object[:mo].to_i > 12
        y_r = (@object[:mo].to_i / 12) - 1
        @object[:mo] -=  y_r * 12
        @object[:yr] = @object[:yr].to_i + y_r
      end
      @object.to_s  # side-effect
      self
    end

    ##
    # Returns `true` if the value adheres to the defined grammar of the
    # datatype.
    #
    # Special case for date and dateTime, for which '0000' is not a valid year
    #
    # @return [Boolean]
    def valid?
      !!(value =~ GRAMMAR)
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string ||= begin
        str = @object[:si] == '-' ? "-P" : "P"
        str << "%dY" % @object[:yr].to_i if @object[:yr]
        str << "%dM" % @object[:mo].to_i if @object[:mo]
        str << "%dD" % @object[:da].to_i if @object[:da]
        str << "T" if @object[:hr] || @object[:mi] || @object[:se]
        str << "%dH" % @object[:hr].to_i if @object[:hr]
        str << "%dM" % @object[:mi].to_i if @object[:mi]
        str << "#{sec_str}S" if @object[:se]
      end
    end

    def plural(v, str)
      "#{v} #{str}#{v.to_i == 1 ? '' : 's'}" if v
    end
    
    ##
    # Returns a human-readable value for the interval
    def humanize(lang = :en)
      @humanize ||= {}
      @humanize[lang] ||= begin
        # Just english, for now
        ar = []
        ar << plural(@object[:yr], "year")
        ar << plural(@object[:mo], "month")
        ar << plural(@object[:da], "day")
        ar << plural(@object[:hr], "hour")
        ar << plural(@object[:mi], "minute")
        ar << plural(sec_str, "second") if @object[:se]
        ar = ar.compact
        last = ar.pop
        first = ar.join(" ")
        res = first.empty? ? last : "#{first} and #{last}"
        @object[:si] == '-' ? "#{res} ago" : res
      end
    end

    ##
    # Equal compares as DateTime objects
    def ==(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid?

      case other
      when Duration
        return super unless other.valid?
        self.to_f == other.to_f
      when String
        self.to_s(:xml) == other
      when Numeric
        self.to_f == other
      when Literal::DateTime, Literal::Time, Literal::Date
        false
      else
        super
      end
    end

    # @return [Float]
    def to_f
      ( @object[:yr].to_i * 365 * 24 * 3600 +
        @object[:mo].to_i * 30 * 24 * 3600 +
        @object[:da].to_i * 24 * 3600 +
        @object[:hr].to_i * 3600 +
        @object[:mi].to_i * 60 +
        @object[:se].to_f
      ) * (@object[:si] == '-' ? -1 : 1)
    end

    # @return [Integer]
    def to_i; Integer(self.to_f); end
    
    private
    # Reverse convert from XSD version of duration
    # XSD allows -P1111Y22M33DT44H55M66.666S with any combination in regular order
    # We assume 1M == 30D, but are out of spec in this regard
    # We only output up to hours
    #
    # @param [String] value XSD formatted duration
    # @return [Duration]
    def parse(value)
      value.to_s.match(GRAMMAR)
    end
    
    def sec_str
      sec = @object[:se].to_f
      ((sec.truncate == sec ? "%d" : "%2.3f") % sec).sub(/(\.[1-9]+)0+$/, '\1')
    end
  end # Duration

  ##
  # A DayTimeDuration literal.
  #
  # dayTimeDuration is a datatype ·derived· from duration by restricting its ·lexical representations· to instances of dayTimeDurationLexicalRep. The ·value space· of dayTimeDuration is therefore that of duration restricted to those whose ·months· property is 0.  This results in a duration datatype which is totally ordered.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#dayTimeDuration
  class DayTimeDuration < Literal
    DATATYPE = XSD.dayTimeDuration
    GRAMMAR  = %r(\A
      (?<si>-)?
      P(?:(?:(?:(?<da>\d+)D)
          )
          (?:T(?:(?:(?:(?<hr>\d+)H)(?:(?<mi>\d+)M)?(?<se>\d+(?:\.\d+)?S)?)
              |  (?:(?:(?<mi>\d+)M)(?:(?<se>\d+(?:\.\d+)?)S)?)
              |  (?:(?<se>\d+(?:\.\d+)?)S)
              )
          )?
       |(?:T(?:(?:(?:(?<hr>\d+)H)(?:(?<mi>\d+)M)?(?<se>\d+(?:\.\d+)?S)?)
            |  (?:(?:(?<mi>\d+)M)(?:(?<se>\d+(?:\.\d+)?)S)?)
            |   (?:(?<se>\d+(?:\.\d+)?)S)
            )
        )
       )
    \z)x.freeze
  end # DayTimeDuration

  ##
  # A YearMonthDuration literal.
  #
  # yearMonthDuration is a datatype ·derived· from duration by restricting its ·lexical representations· to instances of yearMonthDurationLexicalRep.  The ·value space· of yearMonthDuration is therefore that of duration restricted to those whose ·seconds· property is 0.  This results in a duration datatype which is totally ordered.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#yearMonthDuration
  class YearMonthDuration < Literal
    DATATYPE = XSD.yearMonthDuration
    GRAMMAR  = %r(\A
      (?<si>-)?
      P(?:(?:(?:(?:(?<yr>\d+)Y)(?:(?<mo>\d+)M)?)
          |  (?:(?:(?<mo>\d+)M))
          )
       )
    \z)x.freeze
  end # DayTimeDuration
end; end # RDF::Literal
