

Template.contact.events
  "submit #newRequest": (e, t)->
    f = serializeForm($("#newRequest"))
    Meteor.call "sendEmail", f

