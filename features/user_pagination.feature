Feature: Pagination for the Users page

	Background:
		Given many registered users
		And a logged in user

	Scenario: The users page has pagination
		When the user visits the User Search page
		Then the page should have pagination
		And the page should list all the users
