Template.openProjects.events
  'click #newProject': ->
    console.log "new project"
    Session.set "newProject", true
    Session.set "meteorMethod", "createProject"
  'click #files_menu': -> Router.go "sharedocs"
