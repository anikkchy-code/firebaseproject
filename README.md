Firebase Live Score Flutter App
​An academic Flutter project implementing a live score tracking system using MVVM architecture and GetX state management, backed by Firebase Firestore and Authentication.
​🚀 Features
​Live Score Updates: Real-time synchronization using Cloud Firestore.
​Role-Based Security: Public users can view scores, but only authorized administrators can modify or update match scores.


​Authentication: Secure Email/Password login for administrative control.
​State Management: Powered by GetX for reactive UI and efficient routing.
​Dynamic Themes: Built-in Light and Dark theme support.

​⚙️ Setup & Installation
1. the Repository:
git clone <repository-url>

2. Install Dependencies:
flutter pub get

3. Firebase Configuration:
​Place your own google-services.json inside the android/app/ directory (note that it is excluded from public tracking for security).

4. Run the App:
flutter run



​🔑 Admin Credentials (For Testing & Evaluation)
​To test the score update feature, use the following pre-configured administrator account:
​Email: admin@live-score.com
​Password: flutter16


🛡️ Security Rules
​The Firestore rules are configured to permit public read access while restricting write operations exclusively to authenticated users:
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
