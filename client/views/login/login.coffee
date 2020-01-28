Template.loginForm.events
  'submit #login-form': (e, t) ->
      e.preventDefault()
      rawEmail = t.find('#login-email').value
      rawPassword = t.find('#login-password').value

      email = if typeof rawEmail == 'string' then rawEmail.trim() else ''
      password = if typeof rawPassword == 'string' then rawPassword.trim() else ''
      return if rawEmail.length == 0 or password.length == 0


      Meteor.loginWithPassword(email, password, (err) ->
        if err
          console.log err
        else
          console.log "User logged-in"
      )
      return false
