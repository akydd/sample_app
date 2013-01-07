Feature: Follow and Unfollow

	Scenario: A non-followed user's profile has the Follow button
		Given a logged in user and another user
		Then the other user's profile page has the "Follow" button

	Scenario: A followed user's profile has the Unfollow button
		Given a logged in user and another followed user
		Then the other user's profile page has the "Unfollow" button

	Scenario: User follows another user and visit the followed users page
		Given a logged in user and another user
		When the user follows the other user
		And the user visits the Followed Users page
		Then the page should have the subheading "Following"
		And the page should have a link to the other user

	Scenario: User unfollowes another user and visits the followed users page
		Given a logged in user and another followed user
		When the user unfollows the other user
		And the user visits the Followed Users page
		Then the page should not have a link to the other user

	Scenario: User is followed by another user and Visits the followers page
		Given a logged in user and another following user
		When the user visits the Followers page
		Then the page should have the subheading "Followers"
		And the page should have a link to the other user
