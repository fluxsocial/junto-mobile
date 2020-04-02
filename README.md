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

To run call:

```
flutter run --flavor tst
```


## Flavors support

Junto app has additional flavors called `tst` and `prod`. This allows to install 2 apps side by side - one from Google Play (prod) and second from CI or your computer.

To run this flavor call:

```
flutter run --flavor tst
flutter run --flavor prod
```

You can also add launch configuration to VS Code:

```json
"configurations": [
{
    "name": "Flutter Tst",
    "request": "launch",
    "type": "dart",
    "flutterMode": "debug",
    "program": "lib/main.dart",
    "args": [
        "--flavor",
        "tst"
    ],
},
{
    "name": "Flutter Prod",
    "request": "launch",
    "type": "dart",
    "flutterMode": "debug",
    "program": "lib/main.dart",
    "args": [
        "--flavor",
        "prod"
    ],
},
```

## Internationalization

We're using Localizely and arb files to i18n the app. I recommend to use _Flutter Intl_ extension for [VS Code](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) or [Android Studio](https://plugins.jetbrains.com/plugin/13666-flutter-intl) to automatically generate the language files. It should automatically detect the files.

In order to download the arb files from Localizely add your API key to the `scripts/fetch_localizely.sh` file. To download just run it. You can also run it through VS Code tasks. Sample tasks.json:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Download translations from Localizely",
            "type": "shell",
            "command": "./scripts/fetch_localizely.sh",
            "problemMatcher": []
        }
    ]
}
```

To use term in Dart code just call:

```dart
S.of(context).welcome_password_length
```

## Junto Error Codes 
| Error Code  | Message  | Cause  |  
|---|---|---|
|  -1  | Unable to read local user   | The application is unable to read the value of the cached user stored on device.  |   
| -2   | Please check your password  | The passwords entered by the user does not match.   |  
  