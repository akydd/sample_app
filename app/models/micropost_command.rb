class MicropostCommand

  attr_reader :success_message

  def initialize(text, user)
    @success_message = 'Micropost created!'

    attribs = Hash.new

    # set the post content
    attribs[:content] = text

    # is the post a reply to a user who exists?
    reply_username = /^@\w/.match(text).to_s.gsub("@", "")
    unless reply_username.empty?
      reply_user = User.find_by_username(reply_username)
      unless reply_user.nil?
        attribs[:in_reply_to] = reply_user
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
