# 🎯 Rizz AI - Your AI Wingman

A mobile app that helps users generate better messages, rewrite texts, and analyze conversations for dating and social contexts.

## Features

### 1. Rizz Generator
- Generate messages by tone: Funny, Smooth, Savage, Cute, Mysterious, Intellectual
- Context selection: Crush, Dating App, Text, Instagram DM
- AI-powered message generation

### 2. Message Rewriter
- Input your message and get 3 variations:
  - **Safe**: Low risk, polite
  - **Bold**: High confidence, assertive
  - **Playful**: Teasing, witty

### 3. Conversation Analyzer
- Paste your chat conversation
- Get analysis of:
  - Interest level of the other person
  - Emotional tone
  - Red flags in your messages
  - Suggested next reply

## Tech Stack

- **Frontend**: Flutter (Mobile)
- **Backend**: FastAPI (Python)
- **AI**: NVIDIA NIM / Claude via Free Claude Code proxy

## Project Structure

```
rizz-app/
├── mobile/              # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart    # Main app with all screens
│   │   └── services/
│   │       └── api_service.dart
│   └── pubspec.yaml
├── backend/             # FastAPI backend
│   ├── app/
│   │   ├── main.py
│   │   ├── models/
│   │   │   └── schemas.py
│   │   └── services/
│   │       └── nim_service.py
│   └── requirements.txt
└── SPEC.md              # Product specification
```

## Getting Started

### Prerequisites
- Flutter SDK
- Python 3.14+
- Free Claude Code proxy running on port 8082

### Running the Backend

```bash
cd backend
uv sync
uv run python app/main.py
```

The backend will start on `http://localhost:8000`

### Running the Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

### Running the Free Claude Code Proxy

Make sure the proxy is running:

```powershell
cd free-claude-code
uv run uvicorn server:app --host 0.0.0.0 --port 8082
```

Then run Claude Code:

```powershell
$env:ANTHROPIC_AUTH_TOKEN="shrivats"; $env:ANTHROPIC_BASE_URL="http://localhost:8082"; claude
```

## Environment Variables

### Backend (.env)
```
NIM_ENDPOINT=http://localhost:8082
```

### Free Claude Code (.env)
```
NVIDIA_NIM_API_KEY=your-nvidia-api-key
MODEL_OPUS=nvidia_nim/google/gemma-4-31b-it
MODEL_SONNET=nvidia_nim/google/gemma-4-31b-it
MODEL_HAIKU=nvidia_nim/google/gemma-4-31b-it
MODEL=nvidia_nim/google/gemma-4-31b-it
ANTHROPIC_AUTH_TOKEN=""
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/generate` | POST | Generate rizz message |
| `/rewrite` | POST | Rewrite message |
| `/analyze` | POST | Analyze conversation |

## Screenshots

The app features:
- Dark theme UI (Gen Z friendly)
- Purple (#8B5CF6) and pink (#EC4899) accent colors
- Card-based design
- Smooth navigation

## License

MIT License