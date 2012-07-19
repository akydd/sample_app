class Message < ActiveRecord::Base
  attr_accessible :content, :to_user_id

  belongs_to :sender, class_name: "User", foreign_key: :from_user_id
  belongs_to :recipient, class_name: "User", foreign_key: :to_user_id

  validates :content, presence: true
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validate :message_sender_cannot_equal_recipient

  default_scope order: 'messages.created_at DESC'

  private

  def message_sender_cannot_equal_recipient
    if from_user_id == to_user_id
      errors[:base] << "You cannot send a message to yourself!"
    end
  end

end
