<img src="/junto_logo--rainbow.png" width="45px">

# Junto Contribution Guidelines
Hey! We're excited that you're interested in contributing to Junto and thank you for your time in advance. Please review the following guidelines to get started.

## Code of Conduct
We encourage all of our contributors to hold sapcce for mutual respect, diversity, and open-mindedness. 
View our code of conduct here.

## Contribution Examples

* Bug reports
* UX/UI optimizations
* Feature development
* Code clean up
* Translations
* Feedback & New Ideas


## Issue Reporting
Report all issues [here.](https://github.com/juntofoundation/junto-mobile/issues) Remember to add the appropriate labels if applicable. 

## Pull Requests
*The master branch is just a snapshot of the latest stable release. All development should be done in dedicated branches. Do not submit PRs against the master branch.*

As you start developing, create a new branch off of `dev` and make your pull request against that branch.

## Getting Started
### Requirements:
1) Latest version of [Flutter](https://github.com/flutter/flutter) (Junto development team uses branch `beta`)
2) Junto API (Request an API key. We are optimizing our security and will open source our API soon) 

### Building the project:
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


### Flavors support

Junto's mobile app has three flavors called `dev`, `tst` and `prod`. Please use the `dev` flavor to begin contributing to the project. If you'd like to install a separate dev build on your phone through our CI, feel free to reach out at dev@junto.foundation and run the `tst` flavor instead.

```
flutter run --flavor dev --target lib/main_dev.dart
```


You can also access flavors by calling `appConfig.flavor`.


## Internationalization

We're using Localizely and arb files to i18n the app. We recommend using _Flutter Intl_ extension for [VS Code](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) or [Android Studio](https://plugins.jetbrains.com/plugin/13666-flutter-intl) to automatically generate the language files. It should automatically detect the files.

In order to download the arb files from Localizely, add your API key to the `scripts/fetch_localizely.sh` file. To download just run it. You can also run it through VS Code tasks. Sample tasks.json:

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

Sometimes the translations may not refresh/regenerate immediately. In this case, just open any arb file and press CMD+S. The extension should automatically regenerate dart files.

You can read more how to use this approach [here](https://roszkowski.dev/2020/i18n-in-flutter/).
  
## Junto Lingo
* #### Collective - shared space of Junto
* #### Groups - public, private, or secret communities of people
* #### Packs - agent-centric communities that represent one's closet group of friends. Each person has their own pack and can belong to many others. 
* #### Den - profile / private headspace 
* #### Perspective - different ways (feeds) to view the Collective
* #### Expression - posts created through mediums in the Expression Center (i.e. dynamic, shortform, audio, etc.)
* #### Channels - topics you can tag expressions into
* #### Subscriptions - people you follow / subscribe to. Non-mutual relationships.
* #### Connections - your 1st degree connections. Mutual relationships.
* #### Pack Members - your closest group of friends. People you've invited to your pack.


