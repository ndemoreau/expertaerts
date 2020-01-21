Template.projectSubmit.events
  "click #cancelNewProject": ->
    Session.set "newProject", false

  "click #createNewProject": (e, t) ->
    e.preventDefault()

    isValid = AutoForm.validateForm('insertProjectForm')
    return if isValid == false

    form = AutoForm.getFormValues('insertProjectForm')
    currentDoc = form.insertDoc || {}
    Schemas.Project.clean(currentDoc)

    currentDoc.name_fr = if typeof currentDoc.name_fr == 'string' then currentDoc.name_fr else currentDoc.name
    currentDoc.name_en = if typeof currentDoc.name_en == 'string' then currentDoc.name_en else currentDoc.name
    currentDoc.name_nl = if typeof currentDoc.name_nl == 'string' then currentDoc.name_nl else currentDoc.name
    currentDoc.name_it = if typeof currentDoc.name_it == 'string' then currentDoc.name_it else currentDoc.name

    currentDoc.description_fr = if typeof currentDoc.description_fr == 'string' then currentDoc.description_fr else currentDoc.description
    currentDoc.description_en = if typeof currentDoc.description_en == 'string' then currentDoc.description_en else currentDoc.description
    currentDoc.description_nl = if typeof currentDoc.description_nl == 'string' then currentDoc.description_nl else currentDoc.description
    currentDoc.description_it = if typeof currentDoc.description_it == 'string' then currentDoc.description_it else currentDoc.description

    Meteor.call 'createProject', currentDoc, (err, projectId) ->
      if err
        console.log 'createProject', err
      else
        Notifications.success 'Project created'
        Session.set "newProject", false
        Router.go "adminProject", { _id: projectId }


Template.projectSubmit.helpers
  formSchema: ->
    Schemas.Project.pick([
      'name',
      'name_fr',
      'name_en',
      'name_nl',
      'name_it',
      'description',
      'description_fr',
      'description_en',
      'description_nl',
      'description_it'
    ])

  meteorMethod: ->
    meteorMethod = Session.get "meteorMethod"
    if typeof meteorMethod == 'string'
      meteorMethod
    else
      ''
