Schemas.sharedocPicture = new SimpleSchema
  picture_id:
    type: String
    label: "picture_id"
    max: 50
  name:
    type: String
    label: "name"
    max: 50
    optional: true

Schemas.Sharedoc = new SimpleSchema
  name:
    type: String
    label: "Name"
    max: 80

  description:
    type: String
    label: "Description"
    max: 600
    optional: true

  published:
    type: Boolean
    optional: true

  pin:
    type: String
    optional: true

  customer_name:
    type: String
    optional: true

  customer_email:
    type: String
    optional: true

  expertize_nbr:
    type: String
    optional: true

  google_url:
    type: String
    optional: true

  external_id:
    type: String
    optional: true

  invited:
    type: Boolean
    optional: true

  creation_date:
    type: Date
    label: "Creation date"
    defaultValue: new Date()


@Sharedocs = new Meteor.Collection "sharedocs"

Sharedocs.attachSchema(Schemas.Sharedoc)

# Allow/Deny

#Sharedocs.allow({
#  insert: function(sharedocId, doc){
#    return can.createSharedoc(sharedocId);
#  },
#  update:  function(sharedocId, doc, fieldNames, modifier){
#    return can.editSharedoc(sharedocId, doc);
#  },
#  remove:  function(sharedocId, doc){
#    return can.removeSharedoc(sharedocId, doc);
#  }
#});

# Methods
Meteor.methods
  createSharedocFDL: (sharedoc) ->  #Fond du Logement

    console.log "inserting sharedoc FDL..." + sharedoc

    content = sharedoc.split("|")
    v = {}
    p = {}
    v["expertize_nbr"] = content[1]
    p["name"]= "Expertise Fond du Logement" + content[1]
    p["customer_name"] = content[2]
    p["pin"]= content[3]
    p["external_id"]= content[4]
    p["google_url"]=content[5]
    p["creation_date"] = new Date()
    p.published = true
    id = Sharedocs.upsert v
      ,
        $set:p
      , (err, nbr) ->
        if err
          console.log err
        else
          console.log "expertize upsert successful #{nbr}"
    return id

  createSharedoc: (sharedoc) ->

    #    if(can.createSharedoc(Meteor.sharedoc()))
    console.log "inserting sharedoc..."
    p = sharedoc
    p["creation_date"] = new Date()
    p.published = false
    id = Sharedocs.insert(p)
    return id

  updateSharedoc: (sharedoc) ->

    #    if(can.createSharedoc(Meteor.sharedoc()))
    console.log "updating sharedoc..."
    p = sharedoc
    Sharedocs.update(session.Get "currentSharedoc", {$set: sharedoc})

  removeSharedoc: (sharedoc) ->

    #    if(can.removeSharedoc(Meteor.sharedoc(), sharedoc)){
    #      console.log("removing sharedoc" + sharedoc._id);
    Sharedocs.remove sharedoc._id
    return


#    }else{
#      throw new Meteor.Error(403, 'You do not have the rights to delete this sharedoc.')
#    }