class UnfollowCommand

  attr_reader :success_message, :errors

  def initialize(text, user)
    @errors = Array.new

    followed_username = text.split[1] # this is guaranteed to exist
    followed_user = User.find_by_username(followed_username)

    if followed_user.nil?
      @errors << "User #{followed_username} does not exist!"
    else
      @relationship = user.relationships.find_by_followed_id(followed_user)
      @success_message = "Unfollowed #{followed_username}!"
      if @relationship.nil?
        @errors << "You are not following #{followed_user.username}!"
      end
    end
  end

  def execute
    if @errors.empty?
      @relationship.destroy
      return @relationship.destroyed?
    else
      return false
    end
  end
end
