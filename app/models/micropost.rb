class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :parent, class_name: 'Micropost', foreign_key: 'in_reply_to'
  has_many :replies, :inverse 


  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  private

  # return an SQL condition to include:
  # All posts by the user
  # All posts by users the user is following
  # All replies to user's posts
  # All replies to posts by users the user is following
  def self.from_users_followed_by(user)
    followed_user_ids = "Select followed_id from relationships
      where follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user)
  end
end
