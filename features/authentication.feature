Feature: Authentication
	Background:
		Given a user

	Scenario: Authenticad access to protected pages
		When the user signs in
		And  the user tries to access a protected page
		Then the access should succeed

	Scenario: Unauthenticated access to the Edit Profile page
		When the Edit Profile page is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Unauthenticated access to the User Update action
		When the Update Action is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Unauthenticated access to the User Search page
		When the User Search page is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Unauthenticated access to the Followed Users page
		When the Followed Users page is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Unauthenticated access to the Following User page
		When the Following Users page is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Unauthenticated access to the Sent Messages page
		When the Sent Messages page is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Unauthenticated access to the Received Messages page
		When the Received Messages page is accessed without signin
		Then the user is redirected to the Signin page

	Scenario: Authenticated access to the Create User page
		Given a logged in user
		When the Create User page is accessed
		Then the user is redirected to the Home page

	Scenario: Authenticated access to the New User page
		Given a logged in user
		When the New User page is accessed
		Then the user is redirected to the Home page

	Scenario: User tries to edit another user's profile
		Given a logged in user and another user
		When the user tries to edit the other user's profile
		Then the user is redirected to the Home page

	Scenario: User tries to read another user's sent messages
		Given a logged in user and another user
		When the user tries to read the other user's Sent Messages
		Then the user is redirected to the Home page

	Scenario: User tries to read another user's received messages
		Given a logged in user and another user
		When the user tries to read the other user's Received Messages
		Then the user is redirected to the Home page
