S3_keyId = process.env.S3_KEYID_WEB ?= 'AKIAJBAAMVTKUWB7HVSA'
S3_secretId = process.env.S3_ACCESS_KEY_WEB ?= 'NYPh7WNeZRkZMcoiO2QOMNtuQI8wrPRY67eViv7K'

console.log("S3 Key: " + S3_keyId)

Meteor.methods
  s3_key: ->
    check(this.userId, String)

    if typeof S3_keyId == 'string' and S3_keyId.length > 0
      S3_keyId
    else
      throw Error('Invalid value of S3_KEYID_WEB')

  s3_secret: ->
    check(this.userId, String)

    if typeof S3_secretId == 'string' and S3_secretId.length > 0
      S3_secretId
    else
      throw Error('Invalid value of S3_ACCESS_KEY_WEB')
