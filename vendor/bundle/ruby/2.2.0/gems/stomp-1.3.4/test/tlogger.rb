# -*- encoding: utf-8 -*-

require 'logger'	# use the standard Ruby logger .....

=begin

Callback logger for Stomp 1.1+ heartbeat tests.

See the examples directory for a more robust logger example.

=end
class Tlogger

  # Initialize a callback logger class.
  def initialize(init_parms = nil)
    puts
    @log = Logger::new(STDOUT)		# User preference
    @log.level = Logger::DEBUG		# User preference
    @log.info("Logger initialization complete.")
  end

  # Log miscellaneous errors.
  def on_miscerr(parms, errstr)
    begin
      @log.debug "Miscellaneous Error #{info(parms)}"
      @log.debug "Miscellaneous Error String #{errstr}"
    rescue
      @log.debug "Miscellaneous Error oops"
    end
  end

  # Stomp 1.1+ - heart beat send (transmit) failed
  def on_hbwrite_fail(parms, ticker_data)
    begin
      @log.debug "Hbwritef Parms #{info(parms)}"
      @log.debug "Hbwritef Result #{ticker_data.inspect}"
    rescue
      @log.debug "Hbwritef oops"
    end
  end


  # Stomp 1.1+ - heart beat read (receive) failed
  def on_hbread_fail(parms, ticker_data)
    begin
      @log.debug "Hbreadf Parms #{info(parms)}"
      @log.debug "Hbreadf Result #{ticker_data.inspect}"
    rescue
      @log.debug "Hbreadf oops"
    end
  end

  # Stomp 1.1+ - heart beat thread fires
  def on_hbfire(parms, type, firedata)
    begin
      @log.debug "HBfire #{type} " + "=" * 30
      @log.debug "HBfire #{type} Parms #{info(parms)}"
      @log.debug "HBfire #{type} Firedata #{firedata.inspect}"
    rescue
      @log.debug "HBfire #{type} oops"
    end
  end

  private

  def info(parms)
    #
    # Available in the parms Hash:
    # parms[:cur_host]
    # parms[:cur_port]
    # parms[:cur_login]
    # parms[:cur_passcode]
    # parms[:cur_ssl]
    # parms[:cur_recondelay]
    # parms[:cur_parseto]
    # parms[:cur_conattempts]
    # parms[:openstat]
    #
    "Host: #{parms[:cur_host]}, Port: #{parms[:cur_port]}, Login: #{parms[:cur_login]}, Passcode: #{parms[:cur_passcode]}" 
  end
end # of class

