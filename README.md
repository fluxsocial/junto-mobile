
<img src="/junto_logo--rainbow.png" width="60px">

# Junto | A Movement For Authenticity
Junto is a nonprofit, open source, and human-centered social media whose ongoing development is made possible by the support of its grassroots community. Thank you to our volunteers, open source developers, and community members who are
building this momentum. Additional thanks to our sponsors and to those who have contributed to our crowdfunding campaigns, PayPal, and other fundraising mediums. If you're new to Junto, we invite you to join us in our mission to move beyond today's extractive paradigm and inspire authenticity, privacy, and free expression. 

### How you can get involved:
* [Sign up for our alpha and spread the message](https://junto.typeform.com/to/xpwCxK)
* [Consider donating via PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CX87U4QQQX2TW&source=url)
* [Email our founder for partnerships, larger donations, & short-term loan options](mailto:eric@junto.foundation)
* Contribute to our open source development



## Requirements:
1) Latest version of [Flutter](https://github.com/flutter/flutter) (Junto development team uses branch `beta`)
2) Junto API (We are optimizing our security and will open source our API soon) 

## Building the project:
Once you've configured Flutter and obtained an API key from the dev team: 

1) Create a file called `api.dart` in the project's `lib` folder and add the values provided to you by the dev team. 
2) If you are building for Android, create a `key.properties` file in the root of the `android` folder  containing the following:
```
storePassword=dev-password
keyPassword=key-password
keyAlias=key-alias
storeFile=file-location
```
3) And you're all set! Feel free to inspect our code and contribute to the project. PRs are welcome :)


## Flavors support

Junto's mobile app has three flavors called `dev`, `tst` and `prod`. Please use the `dev` flavor to begin contributing to the project. If you'd like to install a separate dev build on your phone through our CI, feel free to reach out at dev@junto.foundation and run the `tst` flavor instead.

```
flutter run --flavor dev --target lib/main_dev.dart
```


You can access current flavor by calling `appConfig.flavor`.

You can also add launch configuration to VS Code:

```json
"configurations": [
    {
        "name": "Flutter Dev Debug",
        "request": "launch",
        "type": "dart",
        "flutterMode": "debug",
        "program": "lib/main_dev.dart",
        "args": [
            "--flavor",
            "dev"
        ]
    },
    {
        "name": "Flutter Dev Debug Mac",
        "request": "launch",
        "type": "dart",
        "program": "lib/main_dev.dart",
        "flutterMode": "debug",
    },
    {
        "name": "Flutter Dev Profile",
        "type": "dart",
        "request": "launch",
        "program": "lib/main_dev.dart",
        "flutterMode": "profile",
        "args": [
            "--flavor",
            "dev"
        ]
    },
    {
        "name": "Flutter Dev Release",
        "type": "dart",
        "request": "launch",
        "program": "lib/main_dev.dart",
        "flutterMode": "release",
        "args": [
            "--flavor",
            "dev"
        ]
    },
    {
        "name": "Flutter Prod Release",
        "type": "dart",
        "request": "launch",
        "program": "lib/main_prod.dart",
        "flutterMode": "release",
        "args": [
            "--flavor",
            "prod"
        ]
    },
]
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

### Troubleshooting

Sometimes the translations may not refresh/regenerate immediately. In such case just open any arb file and press CMD+S. The extension should automatically regenerate dart files.

You can read more how to use this approach [here](https://roszkowski.dev/2020/i18n-in-flutter/).

## Junto Error Codes 
| Error Code  | Message  | Cause  |  
|---|---|---|
|  -1  | Unable to read local user   | The application is unable to read the value of the cached user stored on device.  |   
| -2   | Please check your password  | The passwords entered by the user does not match.   |  
  
