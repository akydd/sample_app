Given /^one micropost for the user$/ do
  @msg = FactoryGirl.create(:micropost, user: @user)
end

When /^the user clicks the delete link$/ do
  click_link "delete"
end

When /^the user tries to post a blank micropost$/ do
  click_button "Submit"
end

When /^the user tries to post a reply to self$/ do
  fill_in 'command', with: "@#{@user.username} here is my reply"
  click_button "Submit"
end

When /^the user posts a valid micropost$/ do
  fill_in 'command', with: "Lorem ipsum"
  click_button "Submit"
end

Then /^the user has no microposts$/ do
  @user.microposts.size.should == 0
end

Then /^the micropost should be deleted$/ do
  steps %Q{
    Then the user has no microposts
  }
end

Then /^no micropost is created$/ do
  steps %Q{
    Then the user has no microposts
  }
end

Then /^the user should have (\d+) post(s?)$/ do |count, plural|
  @user.microposts.size.should == count.to_i
end
