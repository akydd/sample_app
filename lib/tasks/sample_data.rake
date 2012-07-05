namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Admin One",
                       username: "admin1",
                       email: "admin1@test.com",
                       password: "password",
                       password_confirmation: "password")
  admin.toggle!(:admin)

  other_admin = User.create(name: "Admin Two",
                            username: "admin2",
                            email: "admin2@test.com",
                            password: "password",
                            password_confirmation: "password")
  other_admin.toggle!(:admin)

  99.times do |n|
    name = Faker::Name.name
    # Faker::Internet's user_name used ".", so we just take the existing name
    # and replace all non word chars with "_", then trunc to 15 chars.
    username = "user#{n}" 
    email = Faker::Internet.email(name)
    password = "password"
    User.create!(name: name,
                 username: username,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  user1 = User.find_by_username("user1")
  User.all(limit: 20).each do |user|
    
    # create microposts that are replies to user1
    if user != user1 
      3.times do
        user.microposts.create!(content: Faker::Lorem.sentence(5), in_reply_to: user1.id)
      end
    end

    # create microposts that are not replies
    3.times do
      user.microposts.create!(content: Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user = User.find_by_username("user1")
  followed_users = users[4..50]
  followers = users[4..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_replies
  user = User.find_by_username("user1")

  users_replied_to = User.all[5..10]
  replies = user.microposts[8..12]

  # make some of user's posts replies to other users
  replies.zip(users_replied_to).each do |reply, user_replied_to|
    reply.in_reply_to = user_replied_to.id
  end

  # make other users' posts replies to user's posts
  users_who_replied = User.all[10..15]
  users_who_replied.each do |user_who_replied|
    user_who_replied.microposts[5..7].in_reply_to = user.id
  end
end
