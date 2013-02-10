When /^the user (un)?follows the other user$/ do |un|
  steps %Q{
    When the user visits the other user's profile page
  }
  if un.nil? || un.length == 0
    click_button "Follow"
  else
    click_button "Unfollow"
  end
end

When /^the user enters the (un)?follow command for (other|nonexisting|self)$/ do |un, arg|
  if arg == "other"
    fill_in 'command', with: "#{un}follow #{@other_user.username}"
  elsif arg == "nonexisting"
    fill_in 'command', with: "#{un}follow dude"
  elsif arg == "self"
    fill_in 'command', with: "#{un}follow #{@user.username}"
  end
  click_button "Submit" 
end

Then /^the follow command should( not)? succeed$/ do |arg|
  @user.followed_users.size.should == (arg.nil? ? 1 : 0)
end

Then /^the unfollow command should( not)? succeed$/ do |arg|
  @user.followed_users.size.should == (arg.nil? ? 0 : 1)
end

Then /^the other user's profile page has the "(.*?)" button$/ do |text|
  steps %Q{
    When the user visits the other user's profile page
    Then the page should have the "#{text}" button
  }
end

Then /^the page should( not)? have a link to the other user$/ do |arg|
  if arg.nil?
    page.should have_link(@other_user.username, href: user_path(@other_user))
  else
    page.should_not have_link(@other_user.username, href: user_path(@other_user))
  end
end
