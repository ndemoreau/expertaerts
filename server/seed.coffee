
if Meteor.users.find({username: 'admin'}).count() == 0
  console.log "creating user"
  Accounts.createUser
      username: 'admin'
      email: "nicolas@demoreau.be"
      password: "Ingrid07"
if Meteor.users.find({username: 'aerts'}).count() == 0
  Accounts.createUser
    username: 'aerts'
    email: "expertaertsbob@gmail.com"
    password: "aerts2015"
if Projects.find().count() is 0
  Projects.insert
    name: "Champéry"
    description: "tuut"
