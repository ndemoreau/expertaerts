Template.clients.events
  "submit form": (e,instance) ->
    e.preventDefault()
    Session.set "current_file", e.target.fileId.value
    Session.set "current_pin", e.target.pin.value


Template.clients.helpers
  sharedoc: ->
    sharedoc = Sharedocs.findOne
      external_id: Session.get "current_file"
      pin: Session.get "current_pin"
      if sharedoc
        console.log "One document found"
        sharedoc
      else
        console.log "Nothing found"
    sharedoc
  searched: ->
    Session.get "current_file" ? true : false


Template.clients.rendered = ->
  delete Session.keys["current_file"]
  delete Session.keys["current_pin"]
