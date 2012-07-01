class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  private

  # return an SQL condition for users followed by the given user.
  # We include the user's own id as well
  def self.from_users_followed_by(user)
    followed_user_ids = "Select followed_id from relationships
      where follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user)
  end
end
