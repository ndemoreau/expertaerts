Template.sharedocsMenu.events
  'click #projects_menu': -> Router.go "openProjects"
  'click #newSharedoc': ->
    Session.set "newSharedoc", true
    Session.set "meteorMethod", "createSharedoc"
