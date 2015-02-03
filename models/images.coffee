imageStore = new FS.Store.GridFS "images"


@Images = new FS.Collection "images",
  stores: [imageStore]

Meteor.methods
  removeImage: (id) ->
    Images.remove id
    ProjectImages.remove image_id: id
  cleanImages: ->
    project_images = ProjectImages.find()
    project_images.forEach (pi) ->
      image = Images.findOne({_id: pi.image_id})
      #console.log "Project: " + pi.project_id + "image: " + image._id
      unless image
        ProjectImages.remove pi._id
        console.log "Project image removed: " + pi._id
      image=undefined
  makeFirst: (id) ->
    pi = ProjectImages.findOne({image_id: id})
    Projects.update(pi.project_id, $set: {first_image: id})

