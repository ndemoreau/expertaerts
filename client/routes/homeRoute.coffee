Router.map ->
  @route "home",
    path: "/"

  @route "clients",
    path:"/clients"
    layoutTemplate: "clientLayout"
    waitOn: ->
      subs.subscribe "allSharedocs"
      subs.subscribe "allImages"
      subs.subscribe "allProjectImages"
    data: ->
      sharedocs: Sharedocs.find()
      subs.subscribe "allProjectImages", @params._id
      subs.subscribe "allImages"

  @route "projects",
    path:"/projects"
    layoutTemplate: "clientLayout"
    waitOn: ->
      subs.subscribe "allProjects"
      subs.subscribe "allImages"
      subs.subscribe "allProjectImages"
    data: ->
      projects: Projects.find({published: true})

  @route "drive",
    path: "/drive"
    layoutTemplate: "clientLayout"
