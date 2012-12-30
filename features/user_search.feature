Feature: User Searches

	Background:
		Given a user with username "DarthMaul"
		And a user with username "DarthVader"

	Scenario: User search page layout
		Given a logged in user
		When the user visits the User Search page
		Then the page should have the search form
		And the page should have the heading "Users"

	Scenario: Search returns results only for the matching users, single
		Given a logged in user
		When the user searches for "Maul"
		Then the search should return results for "DarthMaul"
		And the search should not return results for "DarthVader"

	Scenario: Search returns results only for the matching users, multiple
		Given a logged in user
		When the user searches for "Darth"
		Then the search should return results for "DarthMaul"
		And the search should return results for "DarthVader"

	Scenario: User searches for someone who does not exist
		Given a logged in user
		When the user searches for "blarg"
		Then the search should return no results
		And the page should have the error message "No users found."

	Scenario: The user search returns no results, and the message clears itself on the next page
		Given a user search with no results
		When the user visits the Home page
		Then the page should not have an error message
