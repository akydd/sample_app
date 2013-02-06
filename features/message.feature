Feature: Direct messages

	Scenario: User sends a message to a follower and views the sent messages page
		Given a logged in user and another following user
		When the user sends a message to the following user
		Then the Sent messages page should have the message

	Scenario: User views received messages
		Given a logged in user and another followed user
		When the user has a message from the followed user
		Then the Received messages page should have the message
