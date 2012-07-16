# Sets the command based on the contents of the text passed into initialize.
class Parser

  attr_reader :command

  def initialize(text, user)
    @content = text.strip
    if /^f(ollow)? \w+$/i.match(@content) # text matched to follow a user
      @command = FollowCommand.new(@content, user)
    elsif /^unfollow \w$/i.match(@content) # text matched to unfollow a user
      @command = UnfollowCommand.new(@content, user)
    elsif /^d(m)? \w+/i.match(@content) # text matched to direct message a user
      @command = MessageCommand.new(@content, user)
    else # all others, create a micropost
      @command = MicropostCommand.new(@content, user)
    end
  end
end
