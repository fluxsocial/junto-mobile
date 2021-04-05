const AwsConfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
      "plugins": {
          "awsCognitoAuthPlugin": {
              "IdentityManager": {
                  "Default": {}
              },
              "CredentialsProvider": {},
              "CognitoUserPool": {
                  "Default": {
                      "PoolId": "us-east-2_Cd8BaNB2i",
                      "AppClientId": "nmf0hgjmq723hrcdc4hjohvqi",
                      "AppClientSecret": "d5t93i5kibul4n0f91r617lgp95m9icvce5ru2hqo10t6fh0f40",
                      "Region": "us-east-2"
                  }
              },
              "Auth": {
                  "Default": {
                      "authenticationFlowType": "USER_SRP_AUTH"
                  }
              }
          }
      }
  }
}''';
