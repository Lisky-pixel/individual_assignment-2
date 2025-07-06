# Project Setup Guide

This guide will help you configure your own Firebase project, set up Firestore security rules, run Dart analyzer, and prepare your submission.

---

## 1. Firebase Setup

### a. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Click **Add project** and follow the prompts.

### b. Add Android/iOS App
- For Android: Register your app (e.g., `com.example.notesapp`). Download `google-services.json` and place it in `android/app/`.
- For iOS: Register your app (e.g., `com.example.notesapp`). Download `GoogleService-Info.plist` and place it in `ios/Runner/`.

### c. Enable Authentication
1. In Firebase Console, go to **Authentication > Sign-in method**.
2. Enable **Email/Password**.

### d. Enable Firestore
1. In Firebase Console, go to **Firestore Database**.
2. Click **Create database** and select production or test mode.

---

## 2. Firestore Security Rules

For development, you can use:
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
- This ensures users can only access their own notes.
- For production, review and tighten rules as needed.

---

## 3. Dart Analyzer Report

To generate a Dart analyzer report:
1. Open a terminal in your project root.
2. Run:
   ```
   flutter analyze > analyzer_report.txt
   ```
3. Attach or screenshot `analyzer_report.txt` for your submission.

---

## 4. README & Architecture Diagram

- **README.md** should include:
  - Project description
  - Setup instructions (refer to this file)
  - How to run the app
  - Folder structure and architecture explanation
  - Any known issues or extra features

- **Architecture Diagram:**
  - Use a tool like draw.io, Lucidchart, or Mermaid (in markdown) to show:
    - Presentation, State, Domain, Data layers
    - How Cubits, Repositories, and UI interact

---

## 5. Submission Checklist
- [ ] Firebase configured and working
- [ ] Firestore rules set
- [ ] Dart analyzer report attached
- [ ] README and architecture diagram included
- [ ] At least 10 meaningful git commits
- [ ] Demo video recorded (showing all flows, your face, and voice)

---

## 6. Running the App
1. Make sure your emulator or device is running.
2. In your project directory, run:
   ```
   flutter run
   ```
3. Test all flows: sign up, login, add/edit/delete notes, logout, and app restart.

---

**Good luck with your submission!** 