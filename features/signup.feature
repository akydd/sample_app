Feature: User signup process

	Background:
		Given the user is not logged in

	Scenario: Visit the signup page
		When the user visits the Signup page
		Then the page should have the heading "Sign up"
		And the page should have the signup form

	Scenario: Signup with bad info
		When the user tries to signup with bad info
		Then the page should have an error message

	Scenario: Signup success
		When the user signs up with valid info
		Then the page should have the success message "Welcome to the Sample App!"
