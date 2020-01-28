module.exports = {
  servers: {
    one: {
      // TODO: set host address, username, and authentication method
      host: '46.101.140.46',
      username: 'root',
      pem: '~/.ssh/id_rsa'
      // password: 'server-password'
      // or neither for authenticate from ssh-agent
    }
  },

  app: {
    // TODO: change app name and path
    name: 'expertaerts',
    path: '../',

    servers: {
      one: {},
    },

    buildOptions: {
      serverOnly: true,
    },

    env: {
      // TODO: Change to your app's url
      // If you are using ssl, it needs to start with https://
      ROOT_URL: 'http://46.101.140.46',
      MONGO_URL: 'mongodb://heroku_app36811562:11tbj0pblc9f4v2i55ce1ihsb5@ds037632-a0.mongolab.com:37632/heroku_app36811562?replicaSet=rs-ds037632',
      // MONGO_URL: 'mongodb://heroku_app36811562:11tbj0pblc9f4v2i55ce1ihsb5@ds221339.mlab.com:21339/heroku_app36811562?connectTimeoutMS=10000&authSource=heroku_app36811562&authMechanism=SCRAM-SHA-1',
      // MONGO_OPLOG_URL: 'mongodb://mongodb/local',
      NEW_RELIC_APP_NAME: 'expertaerts',
      NEW_RELIC_LICENSE_KEY: '0a88d0aa472f4af4b0669a2945c5f45474142d55',
      NEW_RELIC_LOG: 'stdout',
      NEW_RELIC_LOG_LEVEL: 'error',
      NEW_RELIC_NO_CONFIG_FILE: 'true',
      SENDGRID_PASSWORD: 'dxcyxz9a3815',
      SENDGRID_USERNAME: 'app36811562@heroku.com',
      S3_KEYID_WEB: 'AKIAJBAAMVTKUWB7HVSA',
      S3_ACCESS_KEY_WEB: 'NYPh7WNeZRkZMcoiO2QOMNtuQI8wrPRY67eViv7K'
    },

    docker: {
      // change to 'abernix/meteord:base' if your app is using Meteor 1.4 - 1.5
      // image: 'abernix/meteord:node-8.4.0-base',
      image: 'kadirahq/meteord'
    },

    // Show progress bar while uploading bundle to server
    // You might need to disable it on CI servers
    enableUploadProgressBar: true
  },

  // mongo: {
  //   version: '3.6.9',
  //   servers: {
  //     one: {}
  //   }
  // },

  // (Optional)
  // Use the proxy to setup ssl or to route requests to the correct
  // app when there are several apps

  // proxy: {
  //   domains: 'mywebsite.com,www.mywebsite.com',

  //   ssl: {
  //     // Enable Let's Encrypt
  //     letsEncryptEmail: 'email@domain.com'
  //   }
  // }
};
