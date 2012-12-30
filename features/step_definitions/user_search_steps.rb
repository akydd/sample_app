Given /^a user search with no results$/ do
  steps %Q{
    Given a logged in user
    When the user searches for "blarg"
    Then the search should return no results
  }
end

When /^the user searches for "(.*?)"$/ do |name|
  visit users_path
  fill_in 'search', with: name
  click_button 'Search'
end

Then /^the page should have the search form$/ do
  page.should have_selector('input')
end

Then /^the search should return no results$/ do
  page.find(:xpath, 'html/body/div/ul').nil?
end

Then /^the search should return results for "(.*?)"$/ do |name|
  # search all search results for matching name
  @found = false
  page.find(:xpath, '/html/body/div/ul').all('li.a').each do |result|
    if result.text.eql?(name)
      @found = true
      break
    end
  end
  @found
end

Then /^the search should not return results for "(.*?)"$/ do |name|
  # search all search results for matching name
  @not_found = true
  page.find(:xpath, '/html/body/div/ul').all('li.a').each do |result|
    if result.text.eql?(name)
      @not_found = false
      break
    end
  end
  @not_found
end
