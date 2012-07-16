class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name:  "User"
  belongs_to :followed, class_name:  "User"

  validates :follower_id, presence:  true
  validates :followed_id, presence:  true
  validate :disallow_self_referential_relationship

  def disallow_self_referential_relationship
   if followed_id == follower_id
     errors.add(:followed_id, 'cannot refer back to yourself')
   end
  end

end
