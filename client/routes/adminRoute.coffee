Router.map ->
  @route "openProjects",
    layoutTemplate: "adminLayout"
    path: "/admin/"
    waitOn: ->
      subs.subscribe "allProjects"
      subs.subscribe "allProjectImages"
      subs.subscribe "allImages"
    data: ->
      projects: Projects.find()
  @route "adminProject",
    layoutTemplate: "adminLayout"
    path: "/admin/project/:_id"
    waitOn: ->
      subs.subscribe "allProjects"
      subs.subscribe "allImages"
      subs.subscribe "allProjectImages", @params._id
    data: ->
      projects: Projects.find()
      project: Projects.findOne(@params._id)
      project_images: ProjectImages.find({project_id: @params._id}, {sort: {rank: 1}})
  @route "sharedocs",
    layoutTemplate: "adminLayout"
    path: "/admin/sharedocs/"
    waitOn: ->
      subs.subscribe "allSharedocs"
    data: ->
      sharedocs: Sharedocs.find()
  @route "sharedoc",
    layoutTemplate: "adminLayout"
    path: "/admin/sharedocs/:_id"
    waitOn: ->
      subs.subscribe "allSharedocs"
      subs.subscribe "allProjectImages", @params._id
      subs.subscribe "allImages"
    data: ->
      sharedocs: Sharedocs.find()
      sharedoc: Sharedocs.findOne(@params._id)
      project: Sharedocs.findOne(@params._id)  #hack to be able to use images insert in a generic way
      project_images: ProjectImages.find({project_id: @params._id}, {sort: {rank: 1}})

