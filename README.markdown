# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/).

The sample app has the following modifications:
* User has 'username' attribute, which is non-editable after signing up
* User index page has a search form to search all Users by username
* Admin users can delete other Admin users
* Signin is by username and password
* Users have direct messages
	* They are private
	* They can only be sent to followers
	* There are pages to view sent/received messages
* Users can use the micropost form to
	* reply to other users by prefixing posts with _@[username]_
	* follow other users by typing _follow [username]_ or _f [username]_ into the post text box
	* unfollow a user by typing _unfollow [username]_ into the post text box
	* send a direct message to a follower by typing _dm [username] [message
	  text] or _d [username] [message text]

App is deployed to [Heroku](https://sample-app-extended-akydd.herokuapp.com/).
