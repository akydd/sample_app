Feature: User edits his profile

	Background:
		Given a logged in user

	Scenario: Visit the edit profile page
		When the user visits the Edit Profile page
		Then the page should have the heading "Update your profile"
		And the page should have the edit form

	Scenario: Edit with bad info
		When the user edits the profile with bad info
		Then the page should have an error message

	Scenario: Edit success
		When the user edits the profile with valid info
		Then the page should have the success message "Profile updated."
		And the user profile should have the updated info
