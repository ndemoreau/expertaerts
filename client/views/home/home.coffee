
Template.projects.events
  "click .project-item": (e,instance) ->
    Session.set "currentProject", @_id
    $("#common-modal-"+@_id).modal("show")
Template.article.helpers
  project: ->
    Projects.findOne(Session.get "currentProject")
Template.article.helpers
  images: ->
    ProjectImages.find({project_id: @_id}, {sort: {rank: 1}})
  first_image: ->
    image = ProjectImages.findOne({project_id: @_id}, {sort: {rank: 1}})
    if image
      id = image.image_id
    the_image = Images.findOne(id)
Template.articleImage.helpers
  image: ->
    Images.findOne({_id: @image_id})

Template.article.rendered = ->
  article_id = @data._id
  $("#common-modal-"+article_id).on("shown.bs.modal",  ->
    setup_carousel(article_id)
  )
  $("#common-modal-"+article_id).on("hidden.bs.modal",  ->
    destroy_carousel(article_id)
  )

Template.contact.events
  "submit #newRequest": (e, t)->
    f = serializeForm($("#newRequest"))
    Meteor.call "sendEmail", f

@setup_carousel = (article_id) ->
  console.log "article template id: " + article_id
  Session.get "ids"
  owl = $("#common-modal-" + article_id + " .popup-image-gallery")
  debugger
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

@destroy_carousel = (article_id) ->
  owl = $("#common-modal-" + article_id + " .popup-image-gallery")
  owl.data("owlCarousel").destroy() if owl.data("owlCarousel")
