# ✨ Twinkle Quote

Twinkle Quote is a simple and elegant Flutter mobile application that delivers a daily spark of inspiration through carefully curated quotes.  
The app focuses on a calm user experience, beautiful UI, and smooth interactions.

---

## 📱 Features

- 📜 Fetch random inspirational quotes from a public API
- ❤️ Save favorite quotes locally
- 📚 View and manage your favorite quotes
- ✨ Smooth animations and transitions
- 🧊 Glassmorphism-inspired UI elements
- 🔒 Portrait-only orientation for focused reading
- 🚫 No ads, no tracking, no data collection

---

## 🛠 Built With

- **Flutter** (Dart)
- **GoRouter** – navigation and routing
- **SharedPreferences** – local storage for favorites
- **HTTP** – API requests
- **Google Fonts** – typography
- **Custom animations & UI components**

---

## 🌐 API Used

The app uses the **ZenQuotes API** to fetch random quotes.

Example response structure:

```json
[
  {
    "q": "If you don't make things happen then things will happen to you.",
    "a": "Robert Collier",
    "h": "<blockquote>...</blockquote>"
  }
]
```

- `q` → quote text
- `a` → author
- `h` → HTML-formatted quote (not used in the app)

---

## 📸 Screenshots

_(Add screenshots here once uploaded to the Play Store or GitHub)_

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Android device or emulator

### Installation

```bash
git clone https://github.com/hristovskii/twinkle_quote.git
cd twinkle_quote
flutter pub get
flutter run
```

---

## 📦 Build Release (Android)

```bash
flutter build appbundle
```

The generated `.aab` file can be uploaded to Google Play Console.

---

## 🔐 Privacy

Twinkle Quote:
- Does **not** collect personal data
- Does **not** use analytics or tracking
- Stores favorites **locally on device only**

---

## 👤 Author

**Petar Hristovski**  
🌐 https://www.pedzo.xyz

---

## 📄 License

This project is licensed for personal and educational use.  
You are free to explore, learn, and adapt the code for your own projects.

---

✨ *A tiny spark of inspiration, every day.*
# Twinkle-Quote-App
