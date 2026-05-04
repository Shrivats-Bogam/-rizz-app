# Rizz AI Keyboard

An AI-powered keyboard app that provides smart message suggestions while you type in any app (Instagram, WhatsApp, etc.)

## Features

- 🤖 **AI Suggestions**: Get intelligent reply suggestions based on your chat context
- 🎨 **Multiple Tones**: Choose from Funny, Smooth, Savage, Cute, Mysterious
- 😀 **Emoji Keyboard**: Quick access to popular emojis
- 📋 **Copy & Paste**: Tap any suggestion to copy and paste into your chat
- 🌙 **Dark Theme**: Beautiful purple/pink gradient design

## How It Works

1. Open the Rizz Keyboard app
2. Select your desired tone (funny, smooth, savage, cute, mysterious)
3. Type your message or respond to incoming messages
4. AI suggestions appear in the top bar - tap to copy
5. Paste into your chat app (Instagram, WhatsApp, etc.)

## Setup Instructions

### Build the APK

```bash
cd keyboard_app
flutter pub get
flutter build apk --debug
```

### Install on Phone

1. Transfer the APK to your phone
2. Enable "Install from unknown sources" in settings
3. Open and use the app

### How to Use

1. **Open Rizz Keyboard** when you need to reply
2. **Type your message** - AI suggestions appear automatically
3. **Tap a suggestion** to copy it
4. **Paste** into your chat app (Instagram/WhatsApp/Tinder/etc.)

## Project Structure

```
rizz-app/
├── keyboard_app/         # Flutter keyboard app
│   ├── lib/
│   │   └── main.dart     # Keyboard UI with AI integration
│   └── android/          # Android configuration
├── backend/              # FastAPI backend (port 8000)
│   └── app/
│       └── services/
│           └── nim_service.py  # AI service
└── mobile/               # Original standalone app
```

## API Integration

The keyboard connects to the Rizz AI backend:
- Endpoint: `http://10.0.2.2:8000/generate` (Android emulator)
- Or: `http://localhost:8000` (for physical device via port forwarding)

## Fallback Responses

If the backend is unavailable, the app provides intelligent fallback suggestions based on the selected tone.

## Technologies

- **Frontend**: Flutter (Dart)
- **Backend**: FastAPI (Python)
- **AI Engine**: Claude Code (via free-claude-code proxy on port 8082)
- **Target**: Android devices

## Notes

This is the standalone version. For a true system keyboard (like Grammarly), additional Android native code is required to register as an Input Method. The current version works as a "companion app" where users copy suggestions and paste into their chat apps.