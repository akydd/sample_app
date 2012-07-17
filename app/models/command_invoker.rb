# Sets the command based on the contents of the text passed into initialize.
class CommandInvoker

  attr_reader :command

  def initialize(user)
    @user = user
  end

  def command=(text)
    text.strip!

    if /^f(ollow)?\s+\w+$/i.match(text) # text matched to follow a user
      @command = FollowCommand.new(text, @user)
    elsif /^unfollow\s+\w+$/i.match(text) # text matched to unfollow a user
      @command = UnfollowCommand.new(text, @user)
    elsif /^d(m)?\s+\w+/i.match(text) # text matched to direct message a user
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
