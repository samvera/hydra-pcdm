# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Stomp::Message do

  context 'when initializing a new message' do

    context 'with invalid parameters' do
      it 'should return an empty message when receiving an empty string or nil parameter' do
        message = Stomp::Message.new('')
        message.should be_empty
      end

      it 'should raise Stomp::Error::InvalidFormat when receiving a invalid formated message' do
        lambda{ Stomp::Message.new('any invalid format') }.should raise_error(Stomp::Error::InvalidFormat)
      end
    end

    context 'with valid parameters' do
      subject do
        @message = ["CONNECTED\n", "session:host_address\n", "\n", "body value\n", "\000\n"]
        Stomp::Message.new(@message.join)
      end

      it 'should parse the headers' do
        subject.headers.should ==  {'session' => 'host_address'}
      end

      it 'should parse the body' do
        subject.body.should == @message[3]
      end

      it 'should parse the command' do
        subject.command.should == @message[0].chomp
      end
    end
    
    context 'with multiple line ends on the body' do
      subject do
        @message = ["CONNECTED\n", "session:host_address\n", "\n", "body\n\n value\n\n\n", "\000\n"]
        Stomp::Message.new(@message.join)
      end

      it 'should parse the headers' do
        subject.headers.should ==  {'session' => 'host_address'}
      end

      it 'should parse the body' do
        subject.body.should == @message[3]
      end

      it 'should parse the command' do
        subject.command.should == @message[0].chomp
      end
    end
  end
end
