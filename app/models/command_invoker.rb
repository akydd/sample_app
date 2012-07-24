# Sets the command based on the contents of the text passed into initialize.
class CommandInvoker

  attr_reader :command

  def initialize(user)
    @user = user
  end

  def command=(text)
    text.strip!

    if Relationship::FOLLOW_REGEX.match(text) # follow a user
      @command = FollowCommand.new(text, @user)
    elsif Relationship::UNFOLLOW_REGEX.match(text) # unfollow a user
      @command = UnfollowCommand.new(text, @user)
    elsif Message::MESSAGE_REGEX.match(text) # direct message a user
      @command = MessageCommand.new(text, @user)
    else # all others, create a micropost
      @command = MicropostCommand.new(text, @user)
    end
  end

  def execute
    @command.execute
  end

  def success_message
    @command.success_message
  end

  # command's errors may or may not be ActiveRecord:Error
  def errors
    if @command.errors.respond_to?(:full_messages)
      @command.errors.full_messages
    else
      @command.errors
    end
  end

end
