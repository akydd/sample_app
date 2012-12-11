class MessageCommand

  attr_reader :success_message, :message

  def initialize(text, user)
    @success_message = "Message sent!"

    attribs = Hash.new

    recipient_username = text.split[1] # this is guaranteed to !nil
    recipient = User.find_by_username(recipient_username)

    unless recipient.nil?
      attribs['to_user_id'] = recipient.id
    end

    attribs['content'] = text.split(Message::MESSAGE_REGEX)[1].lstrip!

    @message = user.sent_messages.build(attribs)
  end

  def execute
    @message.save
  end

  def errors
    @message.errors
  end

end
