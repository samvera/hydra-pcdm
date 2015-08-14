# -*- encoding: utf-8 -*-

#
# The current require dance for different Ruby versions.
# Change this to suit your requirements.
#
if Kernel.respond_to?(:require_relative)
  require_relative("./stomp11_common")
else
  $LOAD_PATH << File.dirname(__FILE__)
  require "stomp11_common"
end
include Stomp11Common
#
# == Stomp 1.1 Receive Example 2
#
# Purpose: to demonstrate receiving messages using Stomp 1.1, and using
# 'ack => client'.
#
class Receive11Example2
  # Initialize.
  def initialize
  end
  # Run example.
  def run
    conn = get_connection() # Use helper method to obtain a Stomp#connection
    raise "Unexpected protocol level" if conn.protocol != Stomp::SPL_11
    #
    qname = "/queue/nodea.nodeb.nodec"
    #
    uuid = conn.uuid()
    puts "Subscribe id: #{uuid}"
    #
    # Subscribe with client ack mode
    #
    conn.subscribe qname, {'id' => uuid, 'ack' => 'client'} #
    #
    # Once you have subscribed, you may receive as usual
    #
    1.upto(nmsgs()) do
      received = conn.receive
      puts "Received data: #{received.body}"
      #
      # We want now to ACK this message.  In Stomp 1.0, a 'message-id' header was
      # required for the ACK.  In Stomp 1.1, and additional header is required:
      #
      # * 'subscription' => id
      #
      msgid = received.headers['message-id']
      #
      # What you cannot do:
      #
      begin
        conn.ack msgid
      rescue RuntimeError => sre
        puts "Rescue: #{sre}, #{sre.message}"
      end
      #
      # Try a valid 1.1 ACK
      #
      conn.ack msgid, {'subscription' => uuid}
      puts "ACK - msgid: #{msgid}, subscription: #{uuid}"
    end
    #
    # Unsubscribe
    #
    conn.unsubscribe qname, {}, uuid # Second style
    #
    # And finally, disconnect.
    #
    conn.disconnect
  end
end
#
e = Receive11Example2.new
e.run

