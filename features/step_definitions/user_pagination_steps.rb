Then /^the page should have pagination$/ do
  page.should have_selector('div.pagination')
end

Then /^the page should list all the users$/ do
  User.paginate(page: 1).each do |the_user|
    page.should have_selector('li', text: the_user.username)
  end
end
