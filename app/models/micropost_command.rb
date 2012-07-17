class MicropostCommand

  attr_reader :success_message

  def initialize(text, user)
    @success_message = 'Micropost created!'

    attribs = Hash.new

    # set the post content
    attribs['content'] = text

    # if content contains text indicating post is a reply, try to set the
    # in_reply_to field up.  Micropost class contains internal validation
    # to ensure good data.
    reply_username = Micropost.parse_reply_to_username_from_content(text)
    unless reply_username.nil?
      reply_user = User.find_by_username(reply_username)
      unless reply_user.nil?
        attribs['in_reply_to'] = reply_user
      end
    end

    @micropost = user.microposts.build(attribs)
  end

  def execute
    @micropost.save
  end

  def errors
    @micropost.errors
  end

end
