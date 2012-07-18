class Message < ActiveRecord::Base
  attr_accessible :content, :to_user_id

  belongs_to :sender, class_name: "User", foreign_key: :from_user_id
  belongs_to :recipient, class_name: "User", foreign_key: :to_user_id

  validates :content, presence: true
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true

  default_scope order: 'messages.created_at DESC'
end
