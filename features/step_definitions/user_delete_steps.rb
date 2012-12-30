When /^the user deletes the user "(.*?)"$/ do |user|
  steps %Q{
    When the user searches for "#{user}"
  }
  click_link "delete"
end

Then /^the user "(.*?)" should no longer exist$/ do |user|
  steps %Q{
    When the user searches for "#{user}"
    Then the search should return no results
  }
end

Then /^the page should not have delete links$/ do
  page.should_not have_link('delete')
end
