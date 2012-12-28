Given /^a user with username "(.*?)"$/ do |name|
  FactoryGirl.create(:user, username: name)
end

When /^the user searches for "(.*?)"$/ do |name|
  visit users_path
  fill_in 'search', with: name
  click_button 'Search'
end

Then /^the page should have the search form$/ do
  page.should have_selector('input')
end

Then /^the search should return results for "(.*?)"$/ do |name|
  page.find(:xpath, '/html/body/div/ul').all('li').each do |result|
    result.text.should have_text(name)
  end
end

Then /^the search should not return results for "(.*?)"$/ do |name|
  page.find(:xpath, '/html/body/div/ul').all('li').each do |result|
    result.text.should_not have_text(name)
  end
end
