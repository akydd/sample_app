When /^the user sends a message to the following user$/ do
  @msg = FactoryGirl.create(:message, sender: @user, recipient: @other_user,
                            content: "A message from to other!")
end

When /^the user has a message from the followed user$/ do
  @msg = FactoryGirl.create(:message, sender: @other_user,
                           recipient: @user, content: "A message to me!")
end

Then /^the (Sent|Received) messages page should have the message$/ do |arg|
  steps %Q{
    When the user visits the #{arg} Messages page
  }
  page.should have_selector("span.content", text: @msg.content)
  page.should have_link(@other_user.username, href: user_path(@other_user))
end
