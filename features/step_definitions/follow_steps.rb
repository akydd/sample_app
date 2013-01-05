Given /^a logged in user with a (follower|followee)$/ do |follow|
  steps %Q{
    Given a logged in user
  }
  @other_user = FactoryGirl.create(:user)
  if follow == "follower"
    @other_user.follow!(@user)
  else
    @user.follow!(@other_user)
  end
end

Then /^the page should have a link to the (followed|following) user$/ do |type|
  page.should have_link(@other_user.username, href: user_path(@other_user))
end
