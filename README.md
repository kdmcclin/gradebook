# Gradebook

An app to help assigninging and tracking homework via Github issues. It assumes:

* Your students are all on a Github organization team
* You want to assign homework from a (possibly secret) Gist
* You have a dedicated repo where you intend to assign issues to each student, for each assignment

If that matches your use case, a gradebook is running at [greatbook.herokuapp.com](greatbook.herokuapp.com) that you should be able to jump on and use. If it doesn't either [get in touch with me](mailto:james@theironyard.com) or just fork it.

## Using the web UI

* Sign in with Github
* Add a personal Github API access token
* Add a Team (pointing to the organization, team, and repo for issues on Github)
* "Activate" the team to set your default (typically your current set of students)
* Add an Assignment (pointing to a Gist with the contents)
* Click "assign" to create issues for each team member

Other things to know:

* Webhooks should take care of watching for completed issues.
* "Assigning" is idempotent
* You can add ?all=true to the assignments index to see other class assignments

## TODO

* Fix timezone handling
* Better validation and API error handling
* Put some divs on it
* Ensure webhooks are always firing, or set up a periodic job to check, or both
* Lockdown permissions? Other than team membership and potentially centralizing access to private assignment gists, this should all be public information.
