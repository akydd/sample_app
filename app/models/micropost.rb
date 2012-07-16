class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to

  belongs_to :user
  belongs_to :in_reply_to, class_name: 'User', foreign_key: 'in_reply_to'

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # before_save :set_in_reply_to

  default_scope order: 'microposts.created_at DESC'

  def is_reply_to?
    !in_reply_to.nil?
  end

  private

  def set_in_reply_to
    # parse content for "@username"
    username = /^@\w+/.match(self.content).to_s.gsub("@", "")
    # if name is that of saved user, set in_reply_to to that user
    unless username.empty?
      reply_to_user = User.find_by_username(username)
      unless reply_to_user.nil?
        self.in_reply_to = reply_to_user
      end
    end
  end

  # return an SQL condition to include:
  # All posts by the user
  # All posts by users the user is following
  # All replies to user
  # All replies to users the user is following
  def self.from_users_followed_by(user)
    followed_user_ids = "select followed_id from relationships
      where follower_id = :user_id"

    where("user_id IN (#{followed_user_ids})
      OR user_id = :user_id
      OR in_reply_to = :user_id
      OR in_reply_to IN (#{followed_user_ids})",
      user_id: user)

    # Squeel attempt here:
    # this gets the relationships where user is a follower of another user
    # followings = Relationship.where{follower_id == user.id}
    #
    # These work individually
    # Micropost.where{ user_id.in(followings.select{followed_id}) }
    # Micropost.where{ (user_id == user.id) | (in_reply_to == user.id) }
    # This does not work
    # Micropost.where{ user_id.in(followings.select{followed_id}) 
    #  | (user_id == user.id) | (in_reply_to == user.id) }
  end
end
