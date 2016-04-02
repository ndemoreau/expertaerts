Template.projects.events
  "click .project-item": (e,instance) ->
    console.log "click"
    $("#common-modal").remove()
    Session.set "currentProject", @_id
    debugger
    Blaze.renderWithData Template.projectModal, this, document.body
    $("#common-modal").modal("show")
    setup_carousel()

Template.article.helpers
  project: ->
    Projects.findOne(Session.get "currentProject")
  first_image: ->
    image = ProjectImages.findOne({project_id: @_id}, {sort: {rank: 1}})
    if image
      id = image.image_id
    the_image = Images.findOne(id)

Template.projectModal.helpers
  images: ->
    ProjectImages.find({project_id: @_id}, {sort: {rank: 1}})

Template.articleImage.helpers
  image: ->
    Images.findOne({_id: @image_id})

@setup_carousel = () ->
  Session.get "ids"
  owl = $("#common-modal .popup-image-gallery")

  owl.owlCarousel
    autoPlay: 5000
    stopOnHover: true
    navigation: false
    paginationSpeed: 1000
    goToFirstSpeed: 2000
    singleItem: true
    lazyLoad: true
    autoHeight: true
    transitionStyle: "fade"






Template.openProjects.events
  'click #newProject': (e)->
    console.log "new project"
    Session.set "newProject", true
    Session.set "meteorMethod", "createProject"
    Router.go "adminProject", {_id: @projects.fetch()[0]._id}
  'click #files_menu': -> Router.go "sharedocs"
  "click #cleanImages": ->
    Meteor.call "cleanImages"
