#process.argv = _.without process.argv, '--keepalive'

# Buildings

# account imports
# Publish all
Meteor.publish "allUsers", ->
  Accounts.find()
Meteor.publish "allProjects", ->
  Projects.find()
Meteor.publish "allSharedocs", ->
  Sharedocs.find()
Meteor.publish "allImages", ->
  Images.find()
Meteor.publish "allProjectImages", (project_id)->
  ProjectImages.find()

