class FollowCommand

  attr_reader :success_message

  def initialize(text, user)
    attribs = Hash.new

    followed_username = text.split[1] # this is guaranteed to be !nil
    followed_user = User.find_by_username(followed_username)
    unless followed_user.nil?
      attribs['followed_id'] = followed_user.id
    end
    @relationship = user.relationships.build(attribs)

    @success_message = "You are now following #{followed_username}!"
  end

  def execute
    @relationship.save
  end

  def errors
    @relationship.errors
  end

end
