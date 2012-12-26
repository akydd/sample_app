Given /^the user is not registered$/ do
end

Given /^a logged in user$/ do
  # create a user with posts and a follower
  @user = FactoryGirl.create(:user)
  FactoryGirl.create(:micropost, user: @user)
  @other_user = FactoryGirl.create(:user)
  @other_user.follow!(@user)
  sign_in @user
end

When /^the user visits the Home page$/ do
  visit root_path
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

Then /^the page should have the heading "(.*?)"$/ do |arg1|
  page.should have_selector('h1', text: arg1)
end

Then /^the page should have the user feed$/ do
  @user.feed.each do |post|
    page.should have_selector("li##{post.id}", text: post.content)
  end
end

Then /^the page should have the follow links$/ do
  page.should have_link("0 following", href: following_user_path(@user))
  page.should have_link("1 followers", href: followers_user_path(@user))
end

Then /^the page should have the standard links$/ do
    page.should have_link('About')                          
    page.should have_link('Help')
    page.should have_link('Contact')
    page.should have_link('Home')
    page.should have_link('Sign in')
end
