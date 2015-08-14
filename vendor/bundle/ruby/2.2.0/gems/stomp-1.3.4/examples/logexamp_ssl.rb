# -*- encoding: utf-8 -*-

require 'rubygems'
require 'stomp'
require 'logger'  # for the 'local' logger
#
if Kernel.respond_to?(:require_relative)
  require_relative("./examplogger")
else
  $LOAD_PATH << File.dirname(__FILE__)
  require "examplogger"
end
#
# == A STOMP::Connection program which uses the callback logging facility.
#
class SSLLoggerExample
  # Initialize.
  def initialize
  end
  # Run example.
  def run
    llog =        Logger::new(STDOUT)
    llog.level =  Logger::DEBUG
    llog.debug "LESSL Starting"

    # //////////////////////////////////////////////////////////////////////////////
    mylog = Slogger::new  # The client provided STOMP callback logger

    # //////////////////////////////////////////////////////////////////////////////
    user =      ENV['STOMP_USER'] ? ENV['STOMP_USER'] : 'guest'
    password =  ENV['STOMP_PASSWORD'] ? ENV['STOMP_PASSWORD'] : 'guest'
    host =      ENV['STOMP_HOST'] ? ENV['STOMP_HOST'] : 'localhost'
    port =      ENV['STOMP_PORT'] ? ENV['STOMP_PORT'].to_i : 61612
    # //////////////////////////////////////////////////////////////////////////////
    # A hash type connect *MUST* be used to enable callback logging.
    # //////////////////////////////////////////////////////////////////////////////
    hash = { :hosts => [
        {:login => user, :passcode => password, :host => host, :port => port,
        :ssl => true}, # Or provide your insance of SSLParams instead
      ],
      :logger => mylog,	# This enables callback logging!
      :max_reconnect_attempts => 2,
    }

    # //////////////////////////////////////////////////////////////////////////////
    # For a Connection:
    llog.debug "LESSL Connection processing starts"
    conn = Stomp::Connection.new(hash)
    conn.disconnect
    # //////////////////////////////////////////////////////////////////////////////
    llog.debug "LESSL Connection processing complete"

    # //////////////////////////////////////////////////////////////////////////////
    # For a Client:
    llog.debug "LESSL Client processing starts"
    conn = Stomp::Client.new(hash)
    conn.close
    # //////////////////////////////////////////////////////////////////////////////
    llog.debug "LESSL Client processing complete"

    # //////////////////////////////////////////////////////////////////////////////
    # For a Connection with other calls:
    llog.debug "LESSL Connection Enhanced processing starts"
    conn = Stomp::Connection.new(hash)
    #
    dest = "/queue/loggerq1"
    conn.publish dest, "a logger message"
    conn.subscribe dest
    msg = conn.receive
    conn.disconnect
    # //////////////////////////////////////////////////////////////////////////////
    llog.debug "LESSL Connection Enhanced processing complete"

    # //////////////////////////////////////////////////////////////////////////////
    llog.debug "LESSL Ending"
  end
end
#
e = SSLLoggerExample.new
e.run

