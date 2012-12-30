Feature: General Authentication

	Scenario: Signin page has the Sign In heading
		Given the user is not logged in
		When the user visits the Signin page
		Then the page should have the heading "Sign In"

	Scenario: Invalid signin produces an error message
		Given a failed login attempt
		Then the page should have the error message "Invalid"

	Scenario: Signin error message clears itself on later pages
		Given a failed login attempt
		When the user visits the Home page
		Then the page should not have the error message "Invalid"

	Scenario: Valid signin grants access to user links
		Given a logged in user
		When the user visits the Home page
		Then the page should have the user links

	Scenario: Signin link reappears after signing out
		Given a logged in user
		When the user logs out
		Then the page should have the signin link
