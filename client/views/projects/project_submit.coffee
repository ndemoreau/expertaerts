Template.projectSubmit.events
  "click #cancelNewProject": ->
    Session.set "newProject", false



Template.projectSubmit.helpers
  meteorMethod: ->
    Session.get "meteorMethod"