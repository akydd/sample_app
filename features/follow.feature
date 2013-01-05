Feature: Follow and Unfollow

	Scenario: Visit the followed users page
		Given a logged in user with a followee
		When the user visits the Followed Users page
		Then the page should have the subheading "Following"
		And the page should have a link to the followed user

	Scenario: Visit the followers page
		Given a logged in user with a follower
		When the user visits the Followers page
		Then the page should have the subheading "Followers"
		And the page should have a link to the following user
