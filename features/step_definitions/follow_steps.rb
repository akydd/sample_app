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
