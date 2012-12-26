Then /^the page should have the user feed$/ do
  @user.feed.each do |post|
    page.should have_selector("li##{post.id}", text: post.content)
  end
end

Then /^the page should have the follow links$/ do
  page.should have_link("0 following", href: following_user_path(@user))
  page.should have_link("1 followers", href: followers_user_path(@user))
end
