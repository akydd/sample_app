class Message < ActiveRecord::Base
  attr_accessible :content, :to_user_id

  belongs_to :sender, class_name: "User", foreign_key: :from_user_id
  belongs_to :recipient, class_name: "User", foreign_key: :to_user_id

  MESSAGE_REGEX = /^dm?\s+\w+/i

  validates :content, presence: true, length: { maximum: 140 }
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true

  validate :check_users, unless: :missing_sender_or_recipient?
  validate :ensure_recipient_exists

  default_scope order: 'messages.created_at DESC'

  private

  def check_users
    if to_user_id == from_user_id
      errors[:base] << "You cannot send a message to yourself!"
      return
    end

    if !recipient.following?(sender)
      errors[:base] << "Recipient is not following you!"
    end
  end

  def ensure_recipient_exists
    if recipient.nil?
      errors[:base] << "Recipient does not exist!"
    end
  end

  def missing_sender_or_recipient?
    sender.nil? || recipient.nil?
  end
end
