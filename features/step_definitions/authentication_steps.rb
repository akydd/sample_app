When /^the user tries to access a protected page$/ do
  steps %Q{
    When the user visits the Edit Profile page
  }
end

Then /^the access should succeed$/ do
  page.should have_selector('h1', text: 'Update your profile')
end

When /^the Edit Profile page is accessed without signin$/ do
  steps %Q{
    When the user visits the Edit Profile page
  }
end

Then /^the user is redirected to the Signin page$/ do
  page.should have_selector('h1', text: 'Sign In')
end

When /^the Update Action is accessed without signin$/ do
  put user_path(@user)
end

When /^the User Search page is accessed without signin$/ do
  steps %Q{
    When the user visits the User Search page
  }
end

When /^the Followed Users page is accessed without signin$/ do
  steps %Q{
    When the user visits the Followed Users page
  }
end

When /^the Following Users page is accessed without signin$/ do
 steps %Q{
   When the user visits the Followers page
 }
end

When /^the Sent Messages page is accessed without signin$/ do
  steps %Q{
    When the user visits the Sent Messages page
  }
end

When /^the Received Messages page is accessed without signin$/ do
  steps %Q{
    When the user visits the Received Messages page
  }
end

When /^the Create User page is accessed$/ do
  post users_path
end

When /^the New User page is accessed$/ do
  get new_user_path
end

Then /^the user is redirected to the Home page$/ do
  page.should have_selector('h1', text: @user.username)
end

When /^the user tries to edit the other user's profile$/ do
  visit edit_user_path(@other_user)
end

When /^the user tries to read the other user's (Sent|Received) Messages$/ do |arg|
  if arg == "Received"
    visit messages_to_user_path(@other_user)
  else
    visit messages_from_user_path(@other_user)
  end
end

