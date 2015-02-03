Meteor.startup ->
  process.env.MAIL_URL = 'smtp://nicolas%40bloomdesk.com:MarsBloom07@smtp.gmail.com:587/'

Meteor.methods
  sendEmail: (data) ->
    mail_html = "
      <p>Nom: #{data.name}</p>
      <p>Email: #{data.email}</p>
      <p>Téléphone: #{data.tel}</p>
      <p>Message: </p>
      <p>#{data.message}</p>



    "
    Email.send(
      from: "Mars & Moore <info@marsmoore.com>"
      to: "expertaertsbob@gmail.com"
#      to: "nicolas@marsmoore.com"
      subject: "Nouvelle demande via site"
      html: mail_html
    )