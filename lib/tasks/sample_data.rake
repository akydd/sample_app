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
    username = name.gsub(/\W/, "_")[0, 15]
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
  User.all(limit: 6).each do |user|
    50.times do
      user.microposts.create!(content: Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[1..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
