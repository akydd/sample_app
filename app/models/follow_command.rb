class FollowCommand

  def initialize(text, user)
    @success_message = 'Following added!'
    @user = user
  end

  def execute
    #@user.follow!(@other_user)
  end

  def errors
  end

end
