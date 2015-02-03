Template.uploadForm.events
  "change .myFileInput": (event, template) ->
    FS.Utility.eachFile event, (file) ->
      Images.insert file, (err, fileObj) ->
        if err
          console.log err
        else
          current_project = Router.current().params._id
          picture_id= fileObj._id
          pi = {}
          pi.image_id = picture_id
          pi.project_id = current_project
          console.log "Image created: " + pi
          Meteor.call "createProjectImage", pi
  "click .delete_button": ->
    console.log "Image to delete: " + @_id
    Meteor.call "removeImage", @_id
  "click .make_first": ->
    Meteor.call "makeFirst", @_id

Template.image.helpers




Template.imageList.rendered = ->
  setTimeout(->
    el = document.getElementById('images-' + Router.current().params._id)
    sortable = new Sortable(el,
      onEnd: (event, ui) ->
        rank=1
        $(".image-sortable").each( ->
          update_string = {}
          update_string["rank"] = rank
          Meteor.call "UpdateProjectImageByImageId", Blaze.getData(this)._id, update_string
          rank++
        )
    )
  , 1000)