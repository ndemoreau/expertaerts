Template.clients.events
  "submit form": (e,instance) ->
    e.preventDefault()
    Session.set "current_pin", e.target.pin.value
    sharedoc = Sharedocs.findOne
      pin: Session.get "current_pin"
    if sharedoc
      window.open(sharedoc.google_url, '_blank');
      Session.set("nothing_found", false)
      $(".alert").addClass("hidden")
    else
      console.log("nothing found")
      debugger
      Session.set("nothing_found", true)




Template.clients.helpers
  sharedoc: ->
    sharedoc = Sharedocs.findOne
      pin: Session.get "current_pin"
    sharedoc
  searched: ->
    Session.get "current_file" ? true : false
  nothing_found: ->
    if Session.get "nothing_found"
      $(".alert").removeClass("hidden")
      "Aucun dossier trouvé"
Template.ProjectImageList.helpers
  project: ->
    Sharedocs.findOne(@_id)  #hack to be able to use images insert in a generic way
  project_images: ->
    ProjectImages.find({project_id: @_id}, {sort: {rank: 1}})


Template.clients.rendered = ->
  Session.set("nothing_found", false)
  Session.set("emailSent", false)
  delete Session.keys["current_pin"]
