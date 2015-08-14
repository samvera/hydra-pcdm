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
# == Stomp 1.1 Connection Example 1
#
# Purpose: to demonstrate a connect and disconnect sequence using Stomp 1.1.
#
# Note: this example assumes that you have at least the 1.2.0 gem release
# installed.
#
# When you:
#
# * Use a Stomp 1.1 compliant broker
# * Want a Stomp 1.1 level connection and functionality
#
# then your code *must* specifically request that environment.
#
# You need to supply all of the normal values expected of course:
#
# * login - the user name
# * passcode - the password
# * host - the host to connect to
# * port - the port to connect to
#
# Additionaly you are required to supply the 1.1 connection data as documented
# in the Stomp 1.1 specification: http://stomp.github.com/stomp-specification-1.1.html
# You are urged to become familiar with the spec.  It is a short document.
#
# This includes:
#
# * The Stomp version(s) you wish the broker to consider
# * The broker vhost to connect to
#
# You may optionally specify other 1.1 data:
#
# * heartbeat request
#
# Using the stomp gem, you can specify this data in the "connect_headers" Hash
# parameter or a paramaterized connection request.  This example uses a
# parameterized request.
#
class Connection11Example1
  # Initialize
  def initialize
  end
  # Run example
  def run
    #
    # Create connection headers
    # =========================
    #
    # The two headers used here are _required_ by the specification.
    #
    conn_hdrs = {"accept-version" => "1.1",    # Demand a 1.1 connection (use a CSV list if you will consider multiple versions)
      "host" => virt_host,                 # The 1.1 vhost (could be different than connection host)
    }                                      # No heartbeats here:  there will be none for this connection
    #
    # Get a connection
    # ================
    #
    conn = Stomp::Connection.new(login, passcode, host, port,   # Normal connect parms
      false,      # Not reliable, the default for a parameter connection
      5,          # Connect redelay, the default
      conn_hdrs)  # The 1.1 connection parameters
    puts "Connection connect complete"
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
    puts "Connection disconnect complete"
  end
end
#
e = Connection11Example1.new
e.run

