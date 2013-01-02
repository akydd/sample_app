When /^the user signs up with valid info$/ do
  visit signup_path
  fill_in "Name", with: "Example User"
  fill_in "Username", with: "exampleuser"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
  expect { click_button "Sign up" }.to change(User, :count)
end

When /^the user tries to signup with bad info$/ do
  visit signup_path
  expect { click_button "Sign up" }.not_to change(User, :count)
end

Then /^the page should have the signup form$/ do
  page.should have_button "Sign up"
end
