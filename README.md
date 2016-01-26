# Metropolis

This is the API of the project Metropolis.watch

[![CircleCI](https://circleci.com/gh/ecolehetic/metropolis/tree/master.svg?style=svg&circle-token=1ac6c35bd7aad3e49cb3f21bc5e36d7f4105c059)](https://circleci.com/gh/ecolehetic/metropolis/tree/master)

### DB Scheme
### PostgreSQL

##### User
* id
* username (String)
* email (String)
* avatar (References)
* facebook
* twitter
* youtube

##### Project
* id
* title (String)
* youtube_id (String)
* author (Ref)
* comments (Json)
* room_max (Integer)
* cover (References)
* is_in_competion (Boolean)

##### Image
* id
* url (String)
* height (Integer)
* width (Integer)

##### BackstagePost
* id
* project_id (References)
* content (Text)
* image_id (References)
* youtube_id (String)
* comments (Json)

##### BackstagePostAccess
* id
* user_id (References)
* project_id (References)

##### Follow
* id
* user_id (References)
* project_id (References)

##### TeamRole
* id
* project_id (References)
* teamRoleType_id (References)
* user_id (References)

##### TeamRoleType
* id
* name (String)

##### Notification
* id
* user_id (References)
* noificationType_id (References)
* seen_at (Timestamp)
* project_id (References)
* backstagePost_id (References)

##### NotificationType
* id
* content (String)

## Routes
Endpoints are available after /api/v1/.
#### Authentication
**POST**	/register

To signup a new user.

*  username
* email
* password
* password_confirmation

**POST** /session

To  signin a user

By user logins :

* email
* password

By token :

* token

#### Authenticated user data

**GET** /me

Gives authenticated user data

**PUT** /me

To update authenticated user data

* username
* email
* password

**DELETE** /me

To disable user account

#### Authenticated user projects

**GET** /me/projects

Gives all user projects

**POST** /me/projects

Create a new user project

**PUT** /me/projects/:id

Update an existing project

**DELETE** /me/projects/:id

Delete an existing project

## TODO
* Add TDD
* Add Models
* Add Controllers
* Add user Authentification
* Add Authentification APP
* Add admin management
