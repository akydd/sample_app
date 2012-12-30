Then /^the page should have the signin link$/ do
  page.should have_link('Sign in', href: signin_path)
end

When /^the user signs in with invalid info$/ do
  click_button "Sign in"
end

Given /^a failed login attempt$/ do
  visit signin_path
  click_button "Sign in"
end
