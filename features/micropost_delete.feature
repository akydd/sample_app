Feature: Micropost Delete
	Background:
		Given a logged in user
		And one micropost for the user
	
	Scenario:
		When the user visits the Home page
		And the user clicks the delete link
		Then the micropost should be deleted
