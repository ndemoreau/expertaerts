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
        newVal = {}
        oldVal = $.trim $(this).data("value")
        name = $(this).data("name")
        newVal[name] = newValue
        eval($(this).data("context")).update $(this).data("pk"), $set: newVal
        , (error) ->
          if error
            Notifications.error error.message
          Meteor.defer -> $(".editable[data-name=" + name + "]").data('editableContainer').formOptions.value = oldVal
    url = Router.current().url
    if  url.indexOf("#") > -1
      this_url = url.split("#")[1]
      console.log this_url
      goToPage this_url, 1000
    else
      $("html, body").stop().animate
        scrollLeft: 0
        scrollTop: 0
      ,1
  ,0)
