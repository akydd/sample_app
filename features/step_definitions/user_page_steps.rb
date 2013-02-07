Then /^the page should have the user feed$/ do
  @user.feed.each do |post|
    page.should have_selector("li##{post.id}", text: post.content)
  end
end

Then /^the page should have the follow links$/ do
  page.should have_link("0 following", href: following_user_path(@user))
  page.should have_link("1 followers", href: followers_user_path(@user))
end

Then /^the page should have the user info$/ do
  page.should have_selector('h1', text: @user.username)
  page.should have_selector('h4', text: @user.name)
end

Then /^the page should show the microposts$/ do
  page.should have_content(@msg1.content)
  page.should have_content(@msg2.content)
  page.should have_content(@user.microposts.count)
end
