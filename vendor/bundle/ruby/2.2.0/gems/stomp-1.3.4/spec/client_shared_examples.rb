# -*- encoding: utf-8 -*-

require 'spec_helper'

shared_examples_for "standard Client" do

  before(:each) do
    @destination = "/queue/test/ruby/client"
    @message_text = "test_client-#{Time.now.to_i}"
  end

  describe "the closed? method" do
    it "should be false when the connection is open" do
      @mock_connection.stub!(:closed?).and_return(false)
      @client.closed?.should == false
    end

    it "should be true when the connection is closed" do
      @mock_connection.stub!(:closed?).and_return(true)
      @client.closed?.should == true
    end
  end

  describe "the open? method" do
    it "should be true when the connection is open" do
      @mock_connection.stub!(:open?).and_return(true)
      @client.open?.should == true
    end

    it "should be false when the connection is closed" do
      @mock_connection.stub!(:open?).and_return(false)
      @client.open?.should == false
    end
  end

  describe "the subscribe method" do

    before(:each) do
      @mock_connection.stub!(:subscribe).and_return(true)
    end

    it "should raise RuntimeError if not passed a block" do
      lambda {
        @client.subscribe(@destination)
      }.should raise_error
    end

    it "should not raise an error when passed a block" do
      lambda {
        @client.subscribe(@destination) {|msg| received = msg}
      }.should_not raise_error
    end

    it "should raise RuntimeError on duplicate subscriptions" do
      lambda {
        @client.subscribe(@destination)
        @client.subscribe(@destination)
      }.should raise_error
    end

    it "should raise RuntimeError with duplicate id headers" do
      lambda {
        @client.subscribe(@destination, {'id' => 'abcdef'})
        @client.subscribe(@destination, {'id' => 'abcdef'})
      }.should raise_error
    end

  end

end

