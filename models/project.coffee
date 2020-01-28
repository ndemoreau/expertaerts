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

  name_fr:
    type: String
    label: "Name FR"
    max: 50,
    optional: true

  name_en:
    type: String
    label: "Name EN"
    max: 50,
    optional: true

  name_nl:
    type: String
    label: "Name NL"
    max: 50,
    optional: true

  name_it:
    type: String
    label: "Name IT"
    max: 50,
    optional: true

  description:
    type: String
    label: "Description"
    max: 600

  description_fr:
    type: String
    label: "Description FR"
    max: 600,
    optional: true

  description_en:
    type: String
    label: "Description EN"
    max: 600,
    optional: true

  description_nl:
    type: String
    label: "Description NL"
    max: 600,
    optional: true

  description_it:
    type: String
    label: "Description IT"
    max: 600,
    optional: true

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
@Projects.allow
  insert: (projectId, doc) -> typeof Meteor.userId() == 'string' && Match.test(doc, Object)
  update: (projectId, doc) -> typeof Meteor.userId() == 'string' && Match.test(doc, Object)
  remove: (projectId, doc) -> typeof Meteor.userId() == 'string'

# Methods
Meteor.methods
  createProject: (project) ->
    check(this.userId, String)

    #    if(can.createProject(Meteor.project()))
    console.log "inserting project..."
    p = project
    p["creation_date"] = new Date()
    p.published = false
    id = Projects.insert(p)
    return id

  updateProject: (project) ->
    check(this.userId, String)

    #    if(can.createProject(Meteor.project()))
    console.log "updating project..."
    p = project
    Projects.update(session.Get "currentProject", {$set: project})

  removeProject: (project) ->
    check(this.userId, String)

    #    if(can.removeProject(Meteor.project(), project)){
    #      console.log("removing project" + project._id);
    Projects.remove project._id
    return


#    }else{
#      throw new Meteor.Error(403, 'You do not have the rights to delete this project.')
#    }
