Given /^the user is not logged in$/ do
end

Given /^a logged in user$/ do
  # create a user with posts and a follower
  @user = FactoryGirl.create(:user)
  FactoryGirl.create(:micropost, user: @user)
  @other_user = FactoryGirl.create(:user)
  @other_user.follow!(@user)
  sign_in @user
end

Given /^a logged in admin user$/ do
  # create an admin user, no posts or relationships
  @user = FactoryGirl.create(:admin)
  sign_in(@user)
end

When /^the user logs out$/ do
  click_link "Sign out"
end

When /^the user visits the Home page$/ do
  visit root_path
end

When /^the user visits the Signin page$/ do
  visit signin_path
end

When /^the user visits the Help page$/ do
  visit help_path
end

When /^the user visits the About page$/ do
  visit about_path
end

When /^the user visits the Contact page$/ do
  visit contact_path
end

When /^the user visits the User Search page$/ do
  visit users_path
end

Then /^the page should have the heading "(.*?)"$/ do |arg1|
  page.should have_selector('h1', text: arg1)
end

Then /^the page should have the standard links$/ do
    page.should have_link('About')                          
    page.should have_link('Help')
    page.should have_link('Contact')
    page.should have_link('Home')
    page.should have_link('Sign in')
end

Then /^the page should have the user links$/ do
  page.should have_link('Users', href: users_path)
  page.should have_link('Profile', href: user_path(@user))
  page.should have_link('Sent', href: messages_from_user_path(@user))
  page.should have_link('Received', href: messages_to_user_path(@user))
  page.should have_link('Settings', href: edit_user_path(@user))
  page.should have_link('Sign out', href: signout_path)
  page.should_not have_link('Sign in', href: signin_path)
end
