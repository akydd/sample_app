Given /^the user is not logged in$/ do
end

Given /^a logged in( admin)? user( with a profile)?$/ do |admin, profile|
  # create a user
  if admin.nil? || admin.length == 0
    @user = FactoryGirl.create(:user)
  else
    @user = FactoryGirl.create(:admin)
  end

  if !profile.nil? && profile.length != 0
    FactoryGirl.create(:micropost, user: @user)
    @other_user = FactoryGirl.create(:user)
    @other_user.follow!(@user)
  end
  sign_in @user
end

Given /^a user with username "(.*?)"$/ do |name|
  FactoryGirl.create(:user, username: name)
end

When /^the user logs out$/ do
  click_link "Sign out"
end

When /^the user visits the Home page$/ do
  visit root_path
end

When /^the user visits the Signup page$/ do
  visit signup_path
end

When /^the user visits the Signin page$/ do
  visit signin_path
end

When /^the user visits the Edit Profile page$/ do
  visit edit_user_path(@user)
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

When /^the user visits the other user's profile page$/ do
  visit user_path(@other_user)
end

When /^the user visits the Followed Users page$/ do
  visit following_user_path(@user)
end

When /^the user visits the Followers page$/ do
  visit followers_user_path(@user)
end

Then /^the page should have the (sub)?heading "(.*?)"$/ do |sub, arg1|
  if sub.nil? || sub.length == 0 then
    page.should have_selector('h1', text: arg1)
  else
    page.should have_selector('h3', text: arg1)
  end
end

Then /^the page should have the success message "(.*?)"$/ do |msg|
  page.should have_selector('div.alert.alert-success', text: msg)
end

Then /^the page should have the error message "(.*?)"$/ do |msg|
  page.should have_selector('div.alert.alert-error', text: msg)
end

Then /^the page should have an error message$/ do
  page.should have_selector('div.alert.alert-error')
end

Then /^the page should not have the error message "(.*?)"$/ do |msg|
  page.should_not have_selector('div.alert.alert-error', text: msg)
end

Then /^the page should not have an error message$/ do
  page.should_not have_selector('div.alert.alert-error')
end

Then /^the page should have the "(.*?)" button$/ do |text|
  page.should have_button text
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
