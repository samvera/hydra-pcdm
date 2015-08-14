# -*- encoding: utf-8 -*-

#
# The current require dance for different Ruby versions.
# Change this to suit your requirements.
#
if Kernel.respond_to?(:require_relative)
  require_relative("./stomp11_common")
  require_relative("./examplogger")
else
  $LOAD_PATH << File.dirname(__FILE__)
  require "stomp11_common"
  require "examplogger"
end
include Stomp11Common

#
# == Stomp 1.1 Heartbeat Example 1
#
# Purpose: to demonstrate that heart beats can work.
#
class HeartBeatExample1
  # Initialize.
  def initialize
  end
  # Run example.
  def run
    # Create connection headers
    # =========================
    #
    conn_hdrs = {"accept-version" => "1.1", # 1.1
      "host" => virt_host,                  # vhost
      "heart-beat" => "5000,10000",         # heartbeats
    }
    # Create a logger for demonstration purposes
    logger = Slogger.new
    # Connect - a paramaterized request.
    conn = Stomp::Connection.new(login, passcode, host, port,   # Normal connect parms
      false,      # Not reliable, the default for a paramaterized connection
      5,          # Connect redelay, the default for a paramaterized connection
      conn_hdrs)  # The 1.1 connection parameters / headers
    puts "Connection connect complete"
    #
    raise "Unexpected protocol level" if conn.protocol != Stomp::SPL_11
    #
    conn.set_logger(logger) # Connection uses a logger
    sleep 65
    conn.set_logger(nil)    # No logging
    #
    conn.disconnect   # Get out
    puts "Connection disconnect complete"
  end
end
#
e = HeartBeatExample1.new
e.run

