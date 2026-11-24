# Task Manager App

Flutter CRUD Task Manager using **Back4App (Parse Server)** as Backend-as-a-Service.

This repository is ready to push to GitHub. Back4App **Application ID** and **Client Key** are still placeholders and can be added later in `lib/parse_config.dart`.

---

## What is already done

- Flutter project `task_manager` created (Android + Web)
- Parse Flutter SDK added (`parse_server_sdk_flutter`)
- Login with student email
- Register with student email
- Secure logout (Parse session is invalidated)
- Task **Create / Read / Update / Delete**
- Each task is stored with `title`, `description`, and a pointer to the logged-in user
- Login screen shows a banner until Back4App keys are filled in
- Analyzer clean; widget test for the login screen passes

### Not done yet (needs a Back4App account)

- Create the Back4App app
- Paste Application ID and Client Key
- Create the `Task` class in the Back4App database
- End-to-end cloud login and CRUD against the live backend
- Screenshots, YouTube demo video, PPT, Taxila submission

---

## Tech stack

| Layer | Choice |
| --- | --- |
| Frontend | Flutter (Dart) |
| Backend | Back4App (Parse Server) |
| Database | Back4App Cloud Database |
| Version control | GitHub |
| Hosting / run | Local device (Chrome or Android emulator) |

---

## Features

- **User authentication** — register and login with a student email ID
- **CRUD on tasks** — create, list, edit, delete
- **Cloud storage** — tasks go to Back4App after keys are configured
- **Logout** — current session is cleared

### App flow

1. Register or login with student email + password  
2. See your task list  
3. Add a task (title + description)  
4. Tap a task to edit it  
5. Delete a task (with confirmation)  
6. Logout  

---

## Project structure

```text
lib/
  main.dart                 # App start, theme, session gate
  parse_config.dart         # Back4App keys (fill in later)
  parse_bootstrap.dart      # Parse SDK initialize
  services/
    auth_service.dart       # Register, login, logout
    task_service.dart       # Task CRUD
  screens/
    login_screen.dart
    register_screen.dart
    task_list_screen.dart
    task_form_screen.dart   # Create and edit
```

---

## Prerequisites

Install these before you run the app.

### Required software

| Software | Status used in this project | Notes |
| --- | --- | --- |
| Flutter SDK | 3.50.1 (stable) | Installed at `C:\src\flutter` |
| Dart | 3.14.0 | Comes with Flutter |
| Android Studio + Android SDK | SDK 36.0.0 | Needed for Android builds |
| VS Code | Use this | Install **Flutter** and **Dart** extensions |
| Git | Required | For GitHub |
| Google Chrome | Recommended to run locally | `flutter run -d chrome` |
| Back4App account | **Later** | Free account at [back4app.com](https://www.back4app.com) |

### Not required

- Visual Studio Community (only needed for Windows desktop apps)
- iOS / Xcode (this project targets Android and Web)

### Flutter PATH (Windows)

If `flutter` is not recognized in a new terminal:

```powershell
$env:PATH = "C:\src\flutter\bin;" + $env:PATH
```

To make it permanent, add `C:\src\flutter\bin` to the Windows **User PATH**.

### Check the machine

```powershell
flutter doctor
flutter devices
```

You should see Chrome (and optionally an Android emulator or a USB phone).

---

## How to run (without Back4App keys)

The UI will open. Login/register will not talk to the cloud until keys are added.

```powershell
cd C:\Users\taashee\Desktop\Flutter-App
flutter pub get
flutter run -d chrome
```

Other options:

```powershell
flutter emulators
flutter emulators --launch <emulator_id>
flutter run -d <android_device_id>
```

### Useful commands

```powershell
flutter analyze
flutter test
```

---

## Back4App setup (do this later)

### 1. Create an account and app

1. Sign up at [https://www.back4app.com](https://www.back4app.com) (email is more reliable than Google/GitHub if those fail)
2. Create a new Parse app named `TaskManager`
3. Open **App Settings → Security & Keys**
4. Copy:
   - **Application ID**
   - **Client Key**
5. Server URL is always: `https://parseapi.back4app.com`

Do **not** put the **Master Key** in the Flutter app.

### 2. Create the `Task` class

Dashboard → **Database → Browser** → create class **`Task`** with:

| Column | Type |
| --- | --- |
| `title` | String |
| `description` | String |
| `user` | Pointer → `_User` |

Parse already provides `objectId`, `createdAt`, and `updatedAt`. `_User` already exists for authentication.

### 3. Paste keys into the project

Edit `lib/parse_config.dart`:

```dart
class Back4AppKeys {
  static const applicationId = 'PASTE_APPLICATION_ID_HERE';
  static const clientKey = 'PASTE_CLIENT_KEY_HERE';
  static const serverUrl = 'https://parseapi.back4app.com';
  static const taskClassName = 'Task';
}
```

Hot restart the app. The yellow keys banner on the login screen should disappear. Then register a student email and test CRUD.

---

## GitHub

This folder is ready to commit and push.

Suggested first commands:

```powershell
cd C:\Users\taashee\Desktop\Flutter-App
git init
git add .
git commit -m "Add Flutter Task Manager with Back4App placeholders"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

After you add real keys, either:

- keep them only on your machine, or
- if the assignment requires a working demo, you may commit Application ID and Client Key (they are public client keys). Never commit the **Master Key**.

---

## Assignment deliverables (still remaining)

| Deliverable | Status |
| --- | --- |
| Flutter app with auth + CRUD | Done (keys pending) |
| GitHub repo + this README | Ready to push |
| Screenshots of login / CRUD / logout | After keys work |
| YouTube video (~2 min) | After keys work |
| PPT | After keys work |
| Taxila upload | Last step |

---

## Troubleshooting

| Problem | What to do |
| --- | --- |
| `flutter` is not recognized | Add `C:\src\flutter\bin` to PATH, then open a new terminal |
| Login says keys are not set | Fill `lib/parse_config.dart` and hot **restart** (not only hot reload) |
| Back4App signup fails (Failed to fetch / Cloudflare 401) | Try phone hotspot or mobile data, then email signup |
| Cannot run Windows desktop | Expected — Visual Studio is not installed. Use Chrome or Android |
| Tasks not saving | Confirm the `Task` class exists in Back4App Database Browser |
