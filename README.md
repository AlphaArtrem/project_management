# Project Management App
Project Management App made using Flutter, Todoist APIs and Hive

## Installation
1. Clone the repository
```
git@github.com:AlphaArtrem/project_management.git
```
4. Setup [Flutter](https://docs.flutter.dev/get-started/install)
5. Singup and get [Todoist API Key](https://todoist.com/help/articles/find-your-api-token-Jpzx9IIlB)
6. Make sure ```config/config.json``` exists with the following keys

```JSON
{
  "baseUrl": "https://api.todoist.com/rest/v2",
  "appName" : "Task Manager",
  "todoistBearerToken" : "TODOIST_BEARER_TOKEN"
}
```

7. Fetch pub dependencies for Flutter and run the app.
```
flutter pub get
flutter run --dart-define-from-file=configs/config.json
```
8. Build project
```
flutter build apk --release --dart-define-from-file=configs/config.json
flutter build ipa --release --dart-define-from-file=configs/config.json
```