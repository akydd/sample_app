When /^the following user has a message from the user$/ do
  @msg = FactoryGirl.create(:message, sender: @user, recipient: @other_user,
                            content: "A message from to other!")
end

When /^the user has a message from the followed user$/ do
  @msg = FactoryGirl.create(:message, sender: @other_user,
                           recipient: @user, content: "A message to me!")
end

When /^the user sends a message to "(.*?)"$/ do |arg1|
  fill_in 'command', with: "dm #{arg1} message"
  click_button 'Submit'
end

When /^the user sends a message to the other user$/ do
  steps %Q{
    When the user sends a message to "#{@other_user.username}"
  }
end

When /^the user sends a message to self$/ do
  steps %Q{
    When the user sends a message to "#{@user.username}"
  }
end

When /^the user sends a message to a nonexisting user$/ do
  steps %Q{
    When the user sends a message to "does_not_exist"
  }
end

Then /^the message should not be created$/ do
  @user.sent_messages.size.should == 0
end

Then /^the message should be created$/ do
  @user.sent_messages.size.should == 1
  @other_user.received_messages.size.should == 1
end

Then /^the (Sent|Received) messages page should have the message$/ do |arg|
  steps %Q{
    When the user visits the #{arg} Messages page
  }
  page.should have_selector("span.content", text: @msg.content)
  page.should have_link(@other_user.username, href: user_path(@other_user))
end
