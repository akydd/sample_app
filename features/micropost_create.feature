Feature: Micropost creation

	Background:
		Given a logged in user
		And the user visits the Home page

	Scenario: Try to create a blank post
		When the user tries to post a blank micropost
		Then the page should have the error message "Content can't be blank"
		And no micropost is created

	Scenario: Post a reply to one's self
		When the user tries to post a reply to self
		Then the page should have the error message "You cannot reply to yourself!"
		And no micropost is created

	Scenario: Post a vallid micropost
		When the user posts a valid micropost
		Then the user should have 1 post
		And the page should not have an error message
