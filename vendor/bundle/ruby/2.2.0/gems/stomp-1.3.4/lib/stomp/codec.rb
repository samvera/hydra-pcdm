# -*- encoding: utf-8 -*-

module Stomp
  #
  # == Purpose
  #
  # A general CODEC for STOMP 1.1 header keys and values.
  #
  # See:
  #
  # * http://stomp.github.com/index.html
  #
  # for encode/decode rules.
  #
  class HeaderCodec

    public

    # encode encodes header data per the STOMP 1.1 specification.
    def self.encode(in_string = nil)
      return in_string unless in_string
      ev = Stomp::ENCODE_VALUES # avoid typing below
      os = in_string + ""
      0.step(ev.length-2,2) do |i| # [encoded, decoded]
        os.gsub!(ev[i+1], ev[i])
      end
      os
    end

    # decode decodes header data per the STOMP 1.1 specification.
    def self.decode(in_string = nil)
      return in_string unless in_string
      ev = Stomp::DECODE_VALUES # avoid typing below
      os = in_string + ""
      0.step(ev.length-2,2) do |i| # [encoded, decoded]
        os.gsub!(ev[i], ev[i+1])
      end
      os
    end

  end # of class HeaderCodec

end # of module Stomp

