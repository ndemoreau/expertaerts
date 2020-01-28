Router.configure
  layoutTemplate: "basicLayout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFound"
  mainYieldTemplates:
    footer:
      to: "footer"

    header:
      to: "header"

@subs = new SubsManager()

#Router.onBeforeAction (->
#  $(".page").addClass("slideOutRight")
#  current = this
#  Meteor.setTimeout(=>
#    console.log "Waiting"
#    current.next()
#  ,5000)
#), only: ['clients', 'projects']



Router.onAfterAction ->
  setTimeout( ->
    $(".editable").editable
      placement: "inline"
      inputclass: 'input-xxlarge'
      display: ->
      success: (response, newValue) ->
        data = @dataset
        oldVal = if typeof data.value == 'string' then data.value.trim() else ''
        name = if typeof data.name == 'string' then data.name.trim() else ''
        return if name.length == 0

        newVal = {}
        newVal[name] = newValue

        collectionName = data.context
        pk = data.pk

        window[collectionName].update pk, $set: newVal, (error) ->
          if error
            Notifications.error error.message

    url = Router.current().url
    if  url.indexOf("#") > -1
      this_url = url.split("#")[1]
      goToPage this_url, 1000
    else
      $("html, body").stop().animate
        scrollLeft: 0
        scrollTop: 0
      ,1
  , 100)
