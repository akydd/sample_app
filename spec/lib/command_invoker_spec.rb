require 'spec_helper'

describe CommandInvoker do

  let(:user) { FactoryGirl.create(:user) }
  before { @invoker = CommandInvoker.new(user) }

  describe "valid follow commands" do
    it "should set the command to FollowCommand" do
      commands = ["follow user", "f user", "FOLLOW user", "F user",
                  "fOllOw user", "Follow  \t\n  user",
                  "\t\n  follow user  \t\n"]
      commands.each do |follow_text|
        @invoker.command = follow_text
        @invoker.command.should be_an_instance_of FollowCommand
      end
    end
  end

  describe "valid unfollow commands" do
    it "should set the command to UnfollowCommand" do
      commands = ["unfollow user", "UNFOLLOW user", "unFollOW user",
                  "unfollow  \t\n user", "  \t\nunfollow\t\t\nuser\n  "]
      commands.each do |unfollow_text|
        @invoker.command = unfollow_text
        @invoker.command.should be_an_instance_of UnfollowCommand
      end
    end
  end

  describe "valid direct message commands" do
    it "should set the command to MessageCommand" do
      commands = ["d user message here", "D user message here",
                  "dm user message here", "DM user message here",
                  "dM user message here", "Dm user message here",
                  "dm \t\n  user  \t\nmessage here"]
      commands.each do |dm_text|
        @invoker.command = dm_text
        @invoker.command.should be_an_instance_of MessageCommand
        @invoker.command.message.content.should == "message here"
      end
    end
  end

  describe "all other commands" do
    it "should default to the MicropostCommand" do
      commands = ["", "@user hello", "1st post" "@reply", "dm", "d", "DM",
                  "f user text", "follow user text", "follow", "f", "F",
                  "unfollow", "unfollow user invalid text", "dmuser",
                  "followuser", "unfollowuser"]
      commands.each do |post_text|
        @invoker.command = post_text
        @invoker.command.should be_an_instance_of MicropostCommand
      end
    end
  end

end
