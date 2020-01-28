// [https://securityheaders.io]
// [https://stackoverflow.com/questions/15959501/how-to-add-cors-headers-to-a-meteor-app]
Meteor.startup(function () {
  WebApp.connectHandlers.use(function (req, res, next) {
    res.setHeader('Referrer-Policy', 'same-origin')
    res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains')
    res.setHeader('X-Content-Type-Options', 'nosniff')
    res.setHeader('X-Frame-Options', 'DENY')
    res.setHeader('X-Xss-Protection', '1; mode=block')
    return next()
  })
})
