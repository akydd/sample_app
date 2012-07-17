class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to

  belongs_to :user
  belongs_to :in_reply_to, class_name: 'User', foreign_key: 'in_reply_to'

  IN_REPLY_TO_REGEX = /^@\w+/

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validate :in_reply_to_username_match

  default_scope order: 'microposts.created_at DESC'

  def is_reply_to?
    !in_reply_to.nil?
  end

  private

  def in_reply_to_username_match
    in_reply_to_username = Micropost.parse_reply_to_username_from_content(self.content)
    if !in_reply_to_username.nil? && in_reply_to.nil?
      errors[:base] << "User #{in_reply_to_username} does not exist!"
    end
  end

  # Parse text for "@username".  Returns 'username' only.
  def Micropost.parse_reply_to_username_from_content(text)
    name = IN_REPLY_TO_REGEX.match(text).to_s.gsub("@", "")
    if name.empty?
      return nil
    else
      return name
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
