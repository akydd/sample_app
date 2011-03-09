# User factory
Factory.define :user do |user|
  user.name "Stephen Harper"
  user.email "pm@gov.ab.ca"
  user.password "foobar"
  user.password_confirmation "foobar"
end
