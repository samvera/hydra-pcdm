# -*- encoding: utf-8 -*-

#
# Reference: https://github.com/stompgem/stomp/wiki/extended-ssl-overview
#
require "rubygems"
require "stomp"
#
# == SSL Use Case 4 - server *does* authenticate client, client *does* authenticate server
#
# Subcase 4.A - Message broker configuration does *not* require client authentication
#
# - Expect connection success
# - Expect a verify result of 0 becuase the client did authenticate the
#   server's certificate.
#
# Subcase 4.B - Message broker configuration *does* require client authentication
#
# - Expect connection success if the server can authenticate the client certificate
# - Expect a verify result of 0 because the client did authenticate the
#   server's certificate.
#
class ExampleSSL4
  # Initialize.
  def initialize
  end
  # Run example.
  def run
    # Change the following:
    # * location of the client's private key
    # * location of the client's signed certificate
    # * location of the server's CA signed certificate
    ssl_opts = Stomp::SSLParams.new(
      :key_file => "/home/gmallard/sslwork/2013/client.key", # The client's private key
      :cert_file => "/home/gmallard/sslwork/2013/client.crt", # The client's signed certificate
      :ts_files => "/home/gmallard/sslwork/2013/TestCA.crt", # The CA's signed sertificate
      :fsck => true # Check that files exist first
    )
    #
    hash = { :hosts => [
        {:login => 'guest', :passcode => 'guest', :host => 'localhost', :port => 61612, :ssl => ssl_opts},
      ],
      :reliable => false, # YMMV, to test this in a sane manner
    }
    #
    puts "Connect starts, SSL Use Case 4"
    c = Stomp::Connection.new(hash)
    puts "Connect completed"
    puts "SSL Verify Result: #{ssl_opts.verify_result}"
    # puts "SSL Peer Certificate:\n#{ssl_opts.peer_cert}"
    c.disconnect
  end
end
#
e = ExampleSSL4.new
e.run

