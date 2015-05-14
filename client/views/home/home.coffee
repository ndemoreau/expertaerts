

Template.contact.events
  "submit #newRequest": (e, t)->
    e.preventDefault()
    f = serializeForm($("#newRequest"))
    Meteor.call "sendEmail", f
    Session.set("emailSent", true)

Template.contact.helpers
  emailSent: ->
    if Session.get "emailSent" then true else false

