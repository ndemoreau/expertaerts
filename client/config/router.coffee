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

Router.onAfterAction ->
  setTimeout( ->
    $(".editable").editable
      placement: "bottom"
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
      goToPage this_url
    else
      $("html, body").stop().animate
        scrollLeft: 0
        scrollTop: 0
      ,1
    Session.set "newProject", false
  ,0)
