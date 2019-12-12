# Junto | A Movement For Authenticity
Welcome to Junto! This repo contains the source code for our mobile application. 

Requirements: 
To get started building Junto, please ensure your development machine meets the following requirements:
1) Flutter version 1.10.4 or higher (Junto development team uses branch `dev`)
2) Obtain an API key from the development team

Building the project:
Once you've configured Flutter and obtained an API key from the development team you can begin building the project. 

1) Create a file called `api.dart` in the project's `lib` folder contain the values provided to you by the dev team. 
2) If you are building for Android, create a `key.properties` file in the root of the `android` folder  containing the following:
```
storePassword=dev-password
keyPassword=key-password
keyAlias=key-alias
storeFile=file-location
```
3) Congratulations! You should now be able to build the project in debug. Feel free to inspect our code and contribute to the project. PRs are welcome!
