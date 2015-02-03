Router.map ->
  @route "home",
    path: "/"
    waitOn: ->
      subs.subscribe "allProjects"
      subs.subscribe "allImages"
      subs.subscribe "allProjectImages"
    data: ->
      projects: Projects.find({published: true})


  @route "clients",
    path:"/clients"
    waitOn: ->
      subs.subscribe "allSharedocs"
    data: ->
      sharedocs: Sharedocs.find()
    layoutTemplate: "clientLayout"
  @route "drive",
    path: "/drive"
    layoutTemplate: "clientLayout"