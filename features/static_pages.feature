Feature: static pages
	Scenario: Unauthenticated visit to the home page
		Given the user is not logged in
		When the user visits the Home page
		Then the page should have the heading "Sample App"
		And the page should have the standard links

	Scenario: Authenticated visit to the home page
		Given a logged in user with a profile
		When the user visits the Home page
		Then the page should have the user feed
		And the page should have the follow links

	Scenario: Visit the Help page
		Given the user is not logged in
		When the user visits the Help page
		Then the page should have the heading "Help"
		And the page should have the standard links

	Scenario: Visit the About page
		Given the user is not logged in
		When the user visits the About page
		Then the page should have the heading "About Us"
		And the page should have the standard links

	Scenario: Visit the Contact page
		Given the user is not logged in
		When the user visits the Contact page
		Then the page should have the heading "Contact"
		And the page should have the standard links
