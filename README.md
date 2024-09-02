# lakuemas

Flutter version 3.19.2 <br/>
Dart version  3.84.0 <br/>
Xcode 15.2 <br/>
Android Studio 2023.1 <br/>
VS Code 1.86.2 <br/>

Unity Version 2021.3.23f1 <br/>
NDK Version 21.3.6528147 <br/>


Flavors Android
- devAppCenter
- stagingAppCenter
- productionAppCenter (for distribute to appcenter)
- productionGooglePlay (for distribute to Play Store)

Flavors IOS
- dev
- staging
- production


Build app using code push (ShoreBird) <br/>
Android
- shorebird release android --flavor devAppCenter -t lib/main_dev.dart
- shorebird release android --flavor stagingAppCenter -t lib/main_staging.dart
- shorebird release android --flavor productionAppCenter -t lib/main.dart
- shorebird release android --flavor productionGooglePlay -t lib/main.dart
<br/>
IOS <br/>
- shorebird release ios --flavor dev -t lib/main_dev.dart <br/>
- shorebird release ios --flavor staging -t lib/main_staging.dart <br/>
- shorebird release ios --flavor prod -t lib/main.dart <br/>
<br/>
<br/>
Patching app using code push (ShoreBird) <br/>
Android
- shorebird patch android --flavor devAppCenter -t lib/main_dev.dart
- shorebird patch android --flavor stagingAppCenter -t lib/main_staging.dart
- shorebird patch android --flavor productionAppCenter -t lib/main.dart
- shorebird patch android --flavor productionGooglePlay -t lib/main.dart
<br/>
IOS <br/>
- shorebird patch ios --flavor dev -t lib/main_dev.dart <br/>
- shorebird patch ios --flavor staging -t lib/main_staging.dart <br/>
- shorebird patch ios --flavor prod -t lib/main.dart <br/><br/>

For more information about shorebird, just visit this [link](https://docs.shorebird.dev) <br/>
For more information about integration unity to flutter, visit this [link](https://pub.dev/packages/flutter_unity_widget) <br/>
