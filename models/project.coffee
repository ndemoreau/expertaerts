Schemas.projectPicture = new SimpleSchema
  picture_id:
    type: String
    label: "picture_id"
    max: 50
  name:
    type: String
    label: "name"
    max: 50
    optional: true

Schemas.Project = new SimpleSchema
  name:
    type: String
    label: "Name"
    max: 50

  description:
    type: String
    label: "Description"
    max: 600

  published:
    type: Boolean
    optional: true
  first_image:
    type: String
    optional: true

  creation_date:
    type: Date
    label: "Creation date"
    defaultValue: new Date()


@Projects = new Meteor.Collection "projects"

Projects.attachSchema(Schemas.Project)

# Allow/Deny

#Projects.allow({
#  insert: function(projectId, doc){
#    return can.createProject(projectId);
#  },
#  update:  function(projectId, doc, fieldNames, modifier){
#    return can.editProject(projectId, doc);
#  },
#  remove:  function(projectId, doc){
#    return can.removeProject(projectId, doc);
#  }
#});

# Methods
Meteor.methods
  createProject: (project) ->
    
    #    if(can.createProject(Meteor.project()))
    console.log "inserting project..."
    p = project
    p["creation_date"] = new Date()
    p.published = true
    id = Projects.insert(p)
    return id

  updateProject: (project) ->

    #    if(can.createProject(Meteor.project()))
    console.log "updating project..."
    p = project
    Projects.update(session.Get "currentProject", {$set: project})

  removeProject: (project) ->
    
    #    if(can.removeProject(Meteor.project(), project)){
    #      console.log("removing project" + project._id);
    Projects.remove project._id
    return


#    }else{
#      throw new Meteor.Error(403, 'You do not have the rights to delete this project.')
#    }