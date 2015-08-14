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
# == Stomp 1.1 Connection Example 2
#
# Purpose: to demonstrate a connect and disconnect sequence using Stomp 1.1.
#
# This example is like the 'conn11_ex1.rb' example except that a 'hashed'
# connect request is made.
#
class Connection11Example2
  # Initialize.
  def initialize
  end
  # Run example.
  def run
    # Create connection headers
    # =========================
    #
    # The two headers used here are _required_ by the specification.
    #
    conn_hdrs = {"accept-version" => "1.1",    # Demand a 1.1 connection (use a CSV list if you will consider multiple versions)
      "host" => virt_host,                 # The 1.1 vhost (could be different than connection host)
    }                                      # No heartbeats here:  there will be none for this connection
    #
    # Create the connect hash.
    # ========================
    #
    conn_hash = { :hosts => [
        {:login => login, :passcode => passcode, :host => host, :port => port},
      ],
      :reliable => false, # Override default
      :connect_headers => conn_hdrs,
    }
    #
    # Get a connection
    # ================
    #
    conn = Stomp::Connection.new(conn_hash)
    puts "Connection complete"
    #
    # Let's just do some sanity checks, and look around.
    #
    raise "Connection failed!!" unless conn.open?
    #
    # Is this really a 1.1 conection? ('protocol' is a read only connection
    # instance variable. The value will be '1.0' for those types of connections.)
    #
    raise "Unexpected protocol level" if conn.protocol != Stomp::SPL_11
    #
    # The broker _could_ have returned an ERROR frame (unlikely).
    #
    raise "Connect error: #{conn.connection_frame.body}" if conn.connection_frame.command == Stomp::CMD_ERROR
    #
    # Examine the CONNECT response (the connection_frame).
    #
    puts "Connected Headers required to be present:"
    puts "Connect version - \t#{conn.connection_frame.headers['version']}"
    puts
    puts "Connected Headers that are optional:"
    puts "Connect server - \t\t#{conn.connection_frame.headers['server']}"
    puts "Session ID - \t\t\t#{conn.connection_frame.headers['session']}"
    puts "Server requested heartbeats - \t#{conn.connection_frame.headers['heart-beat']}"
    #
    # Finally disconnect
    # ==================
    #
    conn.disconnect   # Business as usual, just like 1.0
    puts "Disconnect complete"
  end
end
#
e = Connection11Example2.new
e.run

