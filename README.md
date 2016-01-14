# GHETTOPOLIS

This is the API of the project Metropolis.watch

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
* Width (Integer)

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
* TeamRoleType (References)
* user_id (References)

##### TeamRoleType
* id
* Name (String)

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

## TODO
* Add TDD
* Add Models
* Add Controllers
* Add user Authentification
* Add Authentification APP
* Add admin management
