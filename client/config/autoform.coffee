SimpleSchema.debug = true


AutoForm.hooks
  insertProjectForm:
    after:
      createProject: (error, result, template) ->
        console.log "hook running"
        unless result is false
          #$('#newProject').modal('hide')
          project = Projects.findOne(result)
          Notifications.success 'Project created: ' + Meteor.call('name', project)
          Router.go "adminProject", project


Meteor.startup ->
  _.extend Notifications.defaultOptions,
    timeout: 10000


  return
  AutoForm.debug()


