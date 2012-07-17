class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name:  "User"
  belongs_to :followed, class_name:  "User"

  validates :follower_id, presence:  true
  validates :followed_id, presence:  true
  validate :ensure_followed_user_exists
  validate :disallow_self_referential_relationship

  private

  def disallow_self_referential_relationship
   if followed_id == follower_id
     errors[:base] << 'You cannot follow yourself!'
   end
  end

  def ensure_followed_user_exists
    if followed_id.nil?
      errors[:base] << 'User to follow does not exist!'
    end
  end
end
