Template.sharedocsMenu.events
  'click #projects_menu': -> Router.go "openProjects"
  'click #files_menu': -> Router.go "sharedocs"

Template.sharedocs.events
  'click #newSharedocButton': ->
    console.log "click"
    Session.set "createSharedoc", true
    Session.set "meteorMethod", "createSharedoc"
  'click #cancelNewSharedoc': ->
    Session.set "createSharedoc", false

Template.sharedocLine.events
  'click #published': ->
    if this.published
      new_val = false
    else
      new_val = true
    Sharedocs.update(this._id, $set: {published: new_val})

Template.sharedoc.events
  'click #published': ->
    if this.published
      new_val = false
    else
      new_val = true
    Sharedocs.update(this._id, $set: {published: new_val})

Template.newSharedoc.events
  "submit #newSharedoc": (e, t) ->
    e.preventDefault()
    f = serializeForm(t.$("#newSharedoc"))
    Meteor.call "createSharedoc", f, (err) ->
      if err
        console.error 'newSharedoc', err
      else
        Session.set "createSharedoc", false
        Session.set "meteorMethod", null
