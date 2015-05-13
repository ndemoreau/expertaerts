process.env.S3_KEYID_WEB = "AKIAJBAAMVTKUWB7HVSA"
process.env.S3_ACCESS_KEY_WEB = "NYPh7WNeZRkZMcoiO2QOMNtuQI8wrPRY67eViv7K"
S3_keyId = process.env.S3_KEYID_WEB
S3_secretId = process.env.S3_ACCESS_KEY_WEB
#S3_keyId = "AKIAJBAAMVTKUWB7HVSA"
#S3_secretId = "NYPh7WNeZRkZMcoiO2QOMNtuQI8wrPRY67eViv7K"
console.log("S3 Key: " + S3_keyId);
Meteor.methods
  s3_key: ->
    if S3_keyId
      S3_keyId
    else
      throw Error()

  s3_secret: ->
    if S3_secretId
      S3_secretId
    else
      throw Error()
