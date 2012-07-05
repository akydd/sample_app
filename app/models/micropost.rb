class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to

  belongs_to :user

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
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id
          OR in_reply_to = :user_id OR in_reply_to IN (#{followed_user_ids})",
          user_id: user)
  end
end
