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
    elsif /^d(m)?\s+\w+/i.match(text) # direct message a user
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

  def errors
    @command.errors
  end

end
