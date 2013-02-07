Feature: The User profile page

	Background:
		Given a logged in user with a profile

	Scenario: Visits the User Profile page
		When the user visits the profile page
		Then the page should have the user info
		And the page should show the microposts
