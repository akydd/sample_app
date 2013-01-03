When /^the user edits the profile with bad info$/ do
  visit edit_user_path(@user)
  click_button "Update"
end

When /^the user edits the profile with valid info$/ do
  visit edit_user_path(@user)
  fill_in "Name", with: "New Name"
  fill_in "Email", with: "new@example.com"
  fill_in "Password", with: "password"
  fill_in "Confirmation", with: "password"
  click_button "Update"
end

Then /^the page should have the edit form$/ do
  page.should have_button "Update"
end

Then /^the user profile should have the updated info$/ do
  visit user_path(@user)
  steps %Q{
    Then the page should have the heading "#{@user.username}"
  }
  page.should have_selector('h4', text: "New Name")
end
