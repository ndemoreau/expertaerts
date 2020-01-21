Schemas.ProjectImage = new SimpleSchema
  project_id:
    type: String
    label: "project_id"
    max: 50

  image_id:
    type: String
    label: "image_id"
    max: 50

  name:
    type: String
    label: "Nom"
    max: 50
    optional: true

  description:
    type: String
    label: "Description"
    max: 50
    optional: true

  rank:
    type: Number
    label: "rank"
    max: 50
    optional: true

  creation_date:
    type: Date
    label: "Creation date"
    defaultValue: new Date()


@ProjectImages = new Meteor.Collection "projectimages"

ProjectImages.attachSchema(Schemas.ProjectImage)

# Allow/Deny

#Projectimages.allow({
#  insert: function(projectimageId, doc){
#    return can.createProjectimage(projectimageId);
#  },
#  update:  function(projectimageId, doc, fieldNames, modifier){
#    return can.editProjectimage(projectimageId, doc);
#  },
#  remove:  function(projectimageId, doc){
#    return can.removeProjectimage(projectimageId, doc);
#  }
#});

ProjectImages.allow
  insert: () -> true

# Methods
Meteor.methods
  createProjectImage: (projectImage) ->
    check(this.userId, String)

    #    if(can.createProjectimage(Meteor.projectimage()))
    console.log "inserting projectimage..."
    p = projectImage
    p["creation_date"] = new Date()
    id = ProjectImages.insert(p)
    console.log "project image inserted: " + id
    return id

  removeProjectimage: (projectImage) ->
    check(this.userId, String)

    #    if(can.removeProjectimage(Meteor.projectimage(), projectimage)){
    #      console.log("removing projectimage" + projectimage._id);
    Projectimages.remove projectimage._id
    return


#    }else{
#      throw new Meteor.Error(403, 'You do not have the rights to delete this projectimage.')
#    }
  UpdateProjectImageByImageId: (image_id, update) ->
    check(this.userId, String)

    console.log "updating: " + image_id + update.rank
    ProjectImages.update({image_id: image_id}, {$set:update})
