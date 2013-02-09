Feature: Direct messages

	Scenario: User sends a message to a follower and views the sent messages page
		Given a logged in user and another following user
		When the following user has a message from the user
		Then the Sent messages page should have the message

	Scenario: User views received messages
		Given a logged in user and another followed user
		When the user has a message from the followed user
		Then the Received messages page should have the message

  Scenario: User sends message to a user who is not following
    Given a logged in user and another user
    When the user visits the Home page
    And the user sends a message to the other user
    Then the message should not be created
    And the page should have the error message "Recipient is not following you!"

  Scenario: User sends message to user who does not exist
    Given a logged in user
    When the user visits the Home page
    And the user sends a message to a nonexisting user
    Then the message should not be created
    And the page should have the error message "Recipient does not exist!"

  Scenario: User sends a message to self
    Given a logged in user
    When the user visits the Home page
    And the user sends a message to self
    Then the message should not be created
    And the page should have the error message "You cannot send a message to yourself!"

