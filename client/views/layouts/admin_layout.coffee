Template.adminLayout.helpers
  username: ->
    Meteor.user().username

Template.adminLayout.events
  'click #logout': ->
    Meteor.logout()