Template.loginForm.events
  'submit #login-form': (e, t) ->
      e.preventDefault()
      email = t.find('#login-email').value
      password = t.find('#login-password').value
      Meteor.loginWithPassword(email, password, (err) ->
        if err
          console.log err
        else
          console.log "User logged-in"
      )
      return false