#  ______     ______     __     __    __     __  __     ______   __  __
# /\  __ \   /\___  \   /\ \   /\ "-./  \   /\ \/\ \   /\__  _\ /\ \_\ \
# \ \  __ \  \/_/  /__  \ \ \  \ \ \-./\ \  \ \ \_\ \  \/_/\ \/ \ \  __ \
#  \ \_\ \_\   /\_____\  \ \_\  \ \_\ \ \_\  \ \_____\    \ \_\  \ \_\ \_\
#   \/_/\/_/   \/_____/   \/_/   \/_/  \/_/   \/_____/     \/_/   \/_/\/_/
#
# azimuth-core/client/views/header.js
#
# Helpers for the header template.
#
Template.header.events
  "click .scroll": (e, instance) ->
    if  e.target.href.indexOf "#" > -1
      e.preventDefault
      target = e.target.href.split("#")[1]
      console.log target
      goToPage target
      toggle_main_menu()

@goToPage = (target) ->
  unless $("#" + target).position() == undefined
    $("html, body").stop().animate
      scrollLeft: $("#" + target).position().left
      scrollTop: $(document).height()
      ,
      1000
      ,
      "easeOutQuint"


Template.header.displayName = ->
  user = Meteor.user()
  user.profile and user.profile.name or user.username or user.emails and user.emails[0] and user.emails[0].address
