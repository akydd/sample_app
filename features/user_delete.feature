Feature: User Delete
	Background:
		Given a user with username "Joe"

	Scenario: An Admin user deletes Joe via the user search page
		Given a logged in admin user
		When the user deletes the user "Joe"
		Then the page should have the success message "User destroyed."
		And the user "Joe" should no longer exist

	Scenario: A non-admin user does not have access to the Delete link
		Given a logged in user
		When the user visits the User Search page
		Then the page should not have delete links

