Template.contact.events
  "submit #newRequest": (e, t)->
    e.preventDefault()
    f = serializeForm($("#newRequest"))

    name = if typeof f.name == 'string' then f.name.trim() else ''
    email = if typeof f.email == 'string' then f.email.trim() else ''
    tel = if typeof f.tel == 'string' then f.tel.trim() else ''
    message = if typeof f.message == 'string' then f.message.trim() else ''

    errors = []
    errors.push({ err: 'Email is required field' }) if email.length == 0
    errors.push({ err: 'Message is required field' }) if message.length == 0
    if errors.length > 0
      Session.set "contact_errors", errors
      return

    Session.set "contact_errors", []
    Session.set "emailSent", true

    contactFormData =
      name: name,
      email: email,
      tel: tel,
      message: message

    Meteor.call "sendEmail", contactFormData, (err) =>
      if err
        console.error 'sendEmail', err


Template.contact.helpers
  errors: ->
    Session.get("contact_errors") || []

  emailSent: ->
    !!Session.get "emailSent"
