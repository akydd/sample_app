class Message < ActiveRecord::Base
  attr_accessible :content, :to_user_id

  belongs_to :sender, class_name: "User", foreign_key: :from_user_id
  belongs_to :recipient, class_name: "User", foreign_key: :to_user_id

  MESSAGE_REGEX = /^dm?\s+\w+/i

  validates :content, presence: true, length: { maximum: 140 }
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validate :message_sender_cannot_equal_recipient, unless: :missing_user?
  validate :recipient_must_follow_sender, unless: :missing_user?
  validate :ensure_recipient_exists

  default_scope order: 'messages.created_at DESC'

  private

  def message_sender_cannot_equal_recipient
    if sender == recipient
      errors[:base] << "You cannot send a message to yourself!"
    end
  end

  def recipient_must_follow_sender
    if !recipient.following?(sender)
      errors[:base] << "Recipient is not following you!"
    end
  end

  def ensure_recipient_exists
    if recipient.nil?
      errors[:base] << "Recipient does not exist!"
    end
  end

  def missing_user?
    sender.nil? || recipient.nil?
  end
end
