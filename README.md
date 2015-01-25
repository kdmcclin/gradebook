# Gradebook

A few utilities to help with assigning and reviewing Iron Yard homework. For now, this is mostly a collection of rake tasks:

* `users:populate` - Creates `Team`s and `User`s for memebers of a selected GitHub team.
* `assignments:new` - Creates a new assignment and creates issues for each member of a selected `Team`. Note: currently, we assume that asssignments link to a markdown file in a GitHub repo, though this may change.
* `assignments:check` - Scans assigned issues, noting newly closed ones, and allowing a chance to review them.
* `assignments:report` - (Not yet implemented) Produces a CSV report with submission times and links for all assignments for a `Team`.

Also potentially helpful:

* `users:shuffle` - Lists team members in a random order (suitable for picking or pairing randomly)

## Setup

* Add [a GitHub access token](https://github.com/blog/1509-personal-api-tokens) to your `application.yml` file (as GITHUB_ACCESS_TOKEN) in order to interact with the GitHub API.
* Run `rake db:setup` (_do not_ migrate the schema up).
* Run `rake users:populate` to pull your initial team.
