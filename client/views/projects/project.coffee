Template.adminProject.events
  'click #published': ->
    if this.published
      new_val = false
    else
      new_val = true
    Projects.update(this._id, $set: {published: new_val})
  'click #deleteProject': ->
    Meteor.call "removeProject", this
    Router.go "openProjects"
    console.log "project removed: " + this._id


Template.adminProject.helpers
  newProject: ->
    Session.get "newProject"
