imageStore = new FS.Store.GridFS "images"

s3Store = new FS.Store.S3 "s3Images",
  bucket: "aerts" #required


@Images = new FS.Collection "images",
  stores: [imageStore]

Meteor.methods
  removeImage: (id) ->
    Images.remove id
    ProjectImages.remove image_id: id
  cleanImages: ->
    console.log "Cleaning..."
    project_images = ProjectImages.find()
    project_images.forEach (pi) ->
      image = Images.findOne({_id: pi.image_id})
      #console.log "Project: " + pi.project_id + "image: " + image._id
      unless image
        #ProjectImages.remove pi._id
        console.log "Project image removed: " + pi._id
      image=undefined

