# Rizz AI - Product Specification

## 1. Product Overview

**Product Name:** Rizz AI (working title: "Rizz")
**Tagline:** Your AI Wingman for Better Conversations

**Core Value Proposition:** An AI-powered conversation assistant that helps users write better messages, get better replies, and build genuine attraction in dating and social contexts.

---

## 2. Target Audience

| Segment | Description | Priority |
|---------|-------------|----------|
| Gen Z (18-27) | Dating app users, socially active | Primary |
| Young Professionals (25-35) | Busy, wants efficiency | Secondary |
| Introverts | Needs help with social confidence | Tertiary |

**User Pain Points:**
- Fear of rejection from bad messages
- Don't know what to say
- Overthinking every text
- Want to be more interesting/flirty
- Low confidence in texting

---

## 3. Product Architecture

### 3.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        MOBILE APP                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │  Rizz    │  │ Message  │  │ Analyzer │  │ Strategy │       │
│  │ Generator│  │ Rewriter │  │   Mode   │  │   Mode   │       │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘       │
│       │             │             │             │              │
│       └─────────────┴─────────────┴─────────────┘              │
│                           │                                     │
│                    ┌──────▼──────┐                              │
│                    │   Core UI   │                              │
│                    └──────┬──────┘                              │
└───────────────────────────│────────────────────────────────────┘
                            │ HTTPS/WSS
┌───────────────────────────▼────────────────────────────────────┐
│                      BACKEND API                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Auth      │  │   AI Proxy  │  │  Analytics  │            │
│  │   Service   │  │   Service   │  │   Service   │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│         │                │                │                    │
│  ┌──────▼────────────────▼────────────────▼──────┐           │
│  │                 DATABASE LAYER                   │           │
│  │  PostgreSQL (Users, Chats)  +  Redis (Cache)    │           │
│  └──────────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────────────┐
│                       AI PROVIDERS                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   OpenAI     │  │ Claude       │  │  NVIDIA NIM │          │
│  │   GPT-4o     │  │  (via proxy) │  │  (local)     │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Microservices Design

| Service | Responsibility | Tech |
|---------|---------------|------|
| Auth Service | User auth, onboarding | Firebase Auth / Clerk |
| User Service | Profile, preferences | FastAPI + SQLAlchemy |
| AI Proxy Service | LLM routing, prompts | FastAPI (reusable from free-claude-code) |
| Generator Service | Rizz generation logic | Prompt engineering |
| Analyzer Service | Chat analysis, scoring | Prompt engineering + rules |
| Analytics Service | Usage tracking, insights | PostgreSQL + custom queries |
| Share Service | Social sharing, viral | Short URLs + OG metadata |

### 3.3 Data Models

**User Model:**
```python
{
  "id": "uuid",
  "email": "string",
  "created_at": "datetime",
  "onboarding_completed": "bool",
  "personality_type": "enum(funny, smooth, savage, cute, mysterious, intellectual)",
  "preferences": {
    "default_tone": "string",
    "target_dating_apps": ["tinder", "bumble", "hinge"],
    "age_range": "range"
  },
  "subscription_tier": "free|premium",
  "stats": {
    "total_generations": "int",
    "streak_days": "int",
    "rizz_score": "float"
  }
}
```

**Chat Analysis Model:**
```python
{
  "id": "uuid",
  "user_id": "uuid",
  "messages": [{"role": "user|other", "content": "string", "timestamp": "datetime"}],
  "analysis": {
    "emotional_tone": "string",
    "interest_level": "float (0-1)",
    "red_flags": ["string"],
    "suggested_replies": ["string"]
  },
  "created_at": "datetime"
}
```

---

## 4. Feature Breakdown

### 4.1 Core Features

| Feature | Priority | Complexity | Description |
|---------|----------|------------|-------------|
| **Rizz Generator** | P0 | Medium | Generate messages by tone + context |
| **Message Rewriter** | P0 | Medium | Improve user's message (3 variants) |
| **Conversation Analyzer** | P1 | High | Analyze chat + suggest replies |
| **Reply Score** | P1 | Medium | Predict response likelihood |
| **Red Flag Detection** | P1 | Medium | Detect issues in messages |
| **Strategy Mode** | P2 | High | Full conversation guidance |
| **Personalization** | P2 | High | Learn user preferences over time |

### 4.2 Feature Specifications

#### Feature 1: Rizz Generator (MVP)

**Input:**
- Tone selection (funny, smooth, savage, cute, mysterious, intellectual)
- Context (crush, dating app, texting, Instagram DM)
- Optional: recipient info (name, personality hints)

**Output:**
- 3-5 generated message options
- Each with confidence score
- Copy + share buttons

**Prompt Design:**
```
You are Rizz, an expert at dating and social conversations.
Generate {tone} messages for {context} context.

Tone: {selected_tone}
Context: {context}
Recipient: {optional_context}

Generate 5 different options that are:
- Authentic to the tone
- Not cringey or try-hard
- Conversation-starting or reply-worthy

Output as JSON:
{
  "messages": [
    {"text": "...", "confidence": 0.85, "why": "..."}
  ]
}
```

#### Feature 2: Message Rewriter (MVP)

**Input:**
- User's original message
- Desired improvement type (safe, bold, playful)

**Output:**
- Improved version
- Explanation of changes
- 3 variations

**Improvement Types:**
- **Safe:** Make it more engaging without risk
- **Bold:** Add confidence/flirtation
- **Playful:** Add humor/levity

#### Feature 3: Conversation Analyzer (Phase 2)

**Input:**
- Chat history (pasted or uploaded)
- Current situation (just matched, ongoing conversation, trying to escalate)

**Output:**
- Emotional tone analysis (excited, interested, bored, distant)
- Interest level score (0-100%)
- Mistakes identified
- Best next reply suggestion

#### Feature 4: Reply Prediction Score

**Input:**
- Message to analyze

**Output:**
- Score (0-100%)
- Breakdown:
  - Clarity: 30%
  - Interest: 30%
  - Timing: 20%
  - Tone match: 20%
- Specific feedback

#### Feature 5: Red Flag Detection

**Detects:**
- Neediness (too many texts, excessive emojis)
- Over-texting (walls of text)
- Awkward phrasing
- Low effort
- Wrong tone for context

**Output:**
- Red flags list with severity
- Suggested fixes

#### Feature 6: Strategy Mode (Phase 3)

**Input:**
- Goal (get number, get date, keep chatting, end gracefully)
- Current conversation state

**Output:**
- Recommended reply timing
- Tone to use next
- Escalation strategy
- Topics to bring up

#### Feature 7: Personalization

**Learns from:**
- Which suggestions user picks
- User's writing style
- Feedback on suggestions (thumbs up/down)

**Adapts:**
- Default tone preference
- Context relevance
- Humor level
- Flirtation comfort level

---

## 5. UI/UX Design

### 5.1 Design Principles

1. **Gen Z Aesthetic:** Clean, bold, playful
2. **Dark Mode First:** Most dating app users prefer dark UI
3. **Minimal Friction:** Get suggestions in 2 taps max
4. **Privacy First:** Clear that chats are not stored/used

### 5.2 Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary (Electric Purple) | #8B5CF6 | Buttons, highlights |
| Secondary (Hot Pink) | #EC4899 | Accents, gradients |
| Background (Deep Black) | #0A0A0F | Main background |
| Surface (Dark Gray) | #1A1A24 | Cards, inputs |
| Text Primary | #FFFFFF | Main text |
| Text Secondary | #9CA3AF | Hints, labels |
| Success (Green) | #10B981 | Good scores |
| Warning (Orange) | #F59E0B | Medium scores |
| Error (Red) | #EF4444 | Low scores, red flags |

### 5.3 Typography

- **Headings:** Inter Bold, 24-32px
- **Body:** Inter Regular, 16px
- **Captions:** Inter Medium, 12px
- **Accent:** Something playful for tags (e.g., "rizz score" badge)

### 5.4 Screen Flow

```
┌──────────────────────────────────────────────────────────────┐
│                      APP ENTRY                                │
│                                                               │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐    │
│  │   Splash    │ ──▶ │   Onboarding│ ──▶ │    Home     │    │
│  │   Screen    │     │   (3 steps) │     │   Screen    │    │
│  └─────────────┘     └─────────────┘     └──────┬──────┘    │
│                                                  │            │
└──────────────────────────────────────────────────│────────────┘
                                                   │
                    ┌──────────────────────────────┼──────────┐
                    │                              │          │
                    ▼                              ▼          ▼
            ┌─────────────┐              ┌─────────────┐ ┌─────────────┐
            │   Rizz      │              │   Message   │ │  Analyzer   │
            │  Generator  │              │  Rewriter    │ │    Mode     │
            │   Screen    │              │   Screen    │ │   Screen    │
            └──────┬──────┘              └──────┬──────┘ └──────┬──────┘
                   │                             │              │
                   ▼                             ▼              ▼
            ┌─────────────┐              ┌─────────────┐ ┌─────────────┐
            │  Results    │              │  Results    │ │  Analysis   │
            │   Cards     │              │   Cards     │ │   Results   │
            └─────────────┘              └─────────────┘ └─────────────┘
```

### 5.5 Screen Details

#### 5.5.1 Onboarding (3 steps)

**Step 1: Welcome**
- Animated logo
- "Your AI Wingman" tagline
- "Get Started" button

**Step 2: Preferences**
- Select default tone (funny/smooth/savage/cute/mysterious/intellectual)
- Select target platforms (Tinder/Bumble/Hinge/Instagram/Text)
- "Skip for now" option

**Step 3: First Name**
- Optional name for personalization
- "Not now" skip option

#### 5.5.2 Home Screen

```
┌─────────────────────────────────────────┐
│  🔥 Streak: 5 days      👤 Profile      │
├─────────────────────────────────────────┤
│                                         │
│    ┌─────────────────────────────────┐  │
│    │         🎯 RIZZ GENERATOR        │  │
│    │   "What's your vibe today?"     │  │
│    │   [Generate Message]            │  │
│    └─────────────────────────────────┘  │
│                                         │
│    ┌─────────────────────────────────┐  │
│    │         ✏️ MESSAGE REWRITER      │  │
│    │   "Make it better"              │  │
│    │   [Paste your message]          │  │
│    └─────────────────────────────────┘  │
│                                         │
│    ┌─────────────────────────────────┐  │
│    │         🔍 CONVERSATION HUNTER   │  │
│    │   "Analyze your chat"           │  │
│    │   [Paste chat]                  │  │
│    └─────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

#### 5.5.3 Rizz Generator Screen

```
┌─────────────────────────────────────────┐
│  ← Back      GENERATOR                  │
├─────────────────────────────────────────┤
│                                         │
│  Tone: [ Funny | Smooth | Savage ]      │
│        [ Cute | Mysterious ]           │
│                                         │
│  Context: ┌─────────────────────────┐   │
│           │ 👤 Crush / 💬 Dating App│   │
│           │ 📱 Instagram DM        │   │
│           │ 💬 Text Message         │   │
│           └─────────────────────────┘   │
│                                         │
│  Optional: Their name (for personalization)
│  ┌─────────────────────────────────────┐ │
│  │ e.g., Alex                          │ │
│  └─────────────────────────────────────┘ │
│                                         │
│  ┌─────────────────────────────────────┐ │
│  │  What are you trying to say?        │ │
│  │                                     │ │
│  └─────────────────────────────────────┘ │
│                                         │
│     [ 🎯 GENERATE RIZZ ]                 │
│                                         │
└─────────────────────────────────────────┘
```

#### 5.5.4 Results Screen

```
┌─────────────────────────────────────────┐
│  ← Back         RESULTS                 │
├─────────────────────────────────────────┤
│                                         │
│  Your Rizz Score: 🔥 85                  │
│  (Based on clarity, tone, timing)      │
│                                         │
│  ┌─────────────────────────────────────┐ │
│  │ Option 1  [Score: 92]               │ │
│  │ ─────────────────────────────────── │ │
│  │ "Okay now I'm really curious...     │ │
│  │ what kind of trouble are you        │ │
│  │ usually up to on Fridays? 😏"       │ │
│  │                                     │ │
│  │ [Copy] [Share] [Try Another]        │ │
│  └─────────────────────────────────────┘ │
│                                         │
│  ┌─────────────────────────────────────┐ │
│  │ Option 2  [Score: 78]               │ │
│  │ ─────────────────────────────────── │ │
│  │ "I'm usually a good listener,       │ │
│  │ but I feel like your stories        │ │
│  │ might be even better in person 👀"  │ │
│  │                                     │ │
│  │ [Copy] [Share] [Try Another]        │ │
│  └─────────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

#### 5.5.5 Analysis Results

```
┌─────────────────────────────────────────┐
│  ← Back        ANALYSIS                 │
├─────────────────────────────────────────┤
│                                         │
│  💬 Their Vibe: They're interested! 🎉  │
│  Interest Level: ████████░░ 82%         │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  🔴 Red Flags Found:                    │
│  • "k" response is too short           │
│  • You're over-pursuing                 │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  💡 Best Reply:                         │
│  "Hey! So I was thinking - there's     │
│  this new coffee place that just        │
│  opened. You seem like someone who'd    │
│  appreciate good coffee. worth checking  │
│  out sometime?"                         │
│                                         │
│  [Copy] [Apply Strategy] [Share]        │
│                                         │
└─────────────────────────────────────────┘
```

### 5.6 Component Library

| Component | States | Description |
|-----------|--------|-------------|
| RizzButton | default, pressed, loading, disabled | Primary CTA |
| ToneChip | unselected, selected | Tone selector |
| ResultCard | default, copied, shared | Generated message |
| ScoreBadge | high, medium, low | Rizz score display |
| RedFlagAlert | warning, error | Issue indicator |
| ChatBubble | user, other, analysis | Message display |

---

## 6. Tech Stack

### 6.1 Mobile App

| Layer | Technology | Rationale |
|-------|------------|-----------|
| Framework | Flutter | Cross-platform, fast dev, great UI |
| State Management | Riverpod | Type-safe, testable, Flutter-native |
| HTTP Client | Dio | Interceptors, retry logic |
| Local Storage | Hive | Fast, lightweight key-value |
| Navigation | GoRouter | Declarative routing |

### 6.2 Backend

| Layer | Technology | Rationale |
|-------|------------|-----------|
| API Framework | FastAPI | Async, auto-docs, Python |
| ORM | SQLAlchemy + asyncpg | Type-safe DB access |
| Auth | Firebase Auth / Clerk | Managed, secure |
| AI Integration | Custom proxy (like free-claude-code) | Route to multiple LLM providers |
| Caching | Redis | Session, rate limiting |
| Analytics | Mixpanel / Amplitude | Event tracking |

### 6.3 AI/LLM

| Provider | Model | Use Case | Cost |
|----------|-------|----------|------|
| OpenAI | GPT-4o | Primary generation | $5/1M input |
| Anthropic | Claude 3.5 | Complex analysis | $3/1M input |
| NVIDIA NIM | Various | Free tier / fallback | Free (rate limited) |

**LLM Routing Strategy:**
1. Simple generation → NVIDIA NIM (free)
2. Complex analysis → GPT-4o
3. Fallback → Claude

### 6.4 Infrastructure

| Service | Provider | Usage |
|---------|----------|-------|
| Hosting | Railway / Render | Backend API |
| CDN | Cloudflare | Static assets |
| Database | Supabase (PostgreSQL) | User data |
| Storage | Supabase Storage | User uploads |

---

## 7. MVP Roadmap

### Phase 1: Core MVP (Weeks 1-4)

**Goal:** Launch with working Rizz Generator + Message Rewriter

| Week | Task | Deliverable |
|------|------|-------------|
| 1 | Setup + Auth | Flutter project, Firebase auth |
| 2 | UI Screens | Home, Generator, Rewriter screens |
| 3 | AI Integration | Connect LLM, write prompts |
| 4 | Polish + Test | Bug fixes, basic testing |

**MVP Features:**
- [ ] User onboarding (3 screens)
- [ ] Rizz Generator (6 tones, 4 contexts)
- [ ] Message Rewriter (3 variations)
- [ ] Copy to clipboard
- [ ] Basic analytics

### Phase 2: Analyzer (Weeks 5-8)

**Goal:** Add conversation analysis

| Week | Task | Deliverable |
|------|------|-------------|
| 5 | Chat input UI | Text area, paste detection |
| 6 | Analysis prompts | Tone, interest, flags |
| 7 | Results display | Visual analysis cards |
| 8 | Testing | User testing feedback |

**Phase 2 Features:**
- [ ] Conversation paste/upload
- [ ] Emotional tone analysis
- [ ] Interest level scoring
- [ ] Red flag detection
- [ ] Next reply suggestions

### Phase 3: Growth Features (Weeks 9-12)

**Goal:** Add viral + retention features

| Week | Task | Deliverable |
|------|------|-------------|
| 9 | Sharing | Share cards, screenshots |
| 10 | Gamification | Streaks, badges, scores |
| 11 | Personalization | Preference learning |
| 12 | Polish | Performance, scaling |

**Phase 3 Features:**
- [ ] Rizz score + share cards
- [ ] Daily streak tracking
- [ ] Personality adaptation
- [ ] Premium features (unlock)
- [ ] Push notifications

### Phase 4: Strategy Mode (Weeks 13-16)

**Goal:** Full conversation guidance

| Week | Task | Deliverable |
|------|------|-------------|
| 13 | Strategy prompts | Goal-based suggestions |
| 14 | Timing logic | When to reply analysis |
| 15 | Escalation paths | Date/number getting |
| 16 | Full testing | End-to-end flow |

---

## 8. Monetization

### 8.1 Freemium Model

| Feature | Free | Premium |
|---------|------|---------|
| Rizz Generator | 10/day | Unlimited |
| Message Rewriter | 5/day | Unlimited |
| Conversation Analyzer | 3/day | Unlimited |
| Reply Score | 5/day | Unlimited |
| Red Flag Detection | Limited | Unlimited |
| Strategy Mode | - | ✓ |
| Advanced Analytics | - | ✓ |
| Personalized Suggestions | - | ✓ |
| No Ads | - | ✓ |

### 8.2 Pricing

| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | 10 generations/day, basic features |
| Pro Monthly | $9.99/mo | Everything, unlimited |
| Pro Yearly | $79.99/yr | Everything, save 33% |

### 8.3 Revenue Streams

1. **Subscriptions** (primary)
2. **Pay-per-use** (for non-subscribers)
3. **Sponsored suggestions** (optional, careful with trust)
4. **Affiliate** (dating apps, products)

---

## 9. Growth Strategy

### 9.1 Target: 100K Users

**Month 1-3: Launch (Goal: 1K)**
- Product Hunt launch
- Beta tester recruitment (dating subreddits, Discord)
- Reddit marketing (r/tinder, r/dating, r/seduction)
- TikTok demo videos

**Month 4-6: Growth (Goal: 10K)**
- Influencer partnerships (dating coaches, seduction community)
- ASO optimization (App Store keywords)
- Referral program launch
- Content marketing (blog on dating tips)

**Month 7-12: Scale (Goal: 100K)**
- TikTok/Instagram Reels viral campaign
- PR/media coverage
- Dating app partnerships
- College campus outreach

### 9.2 Viral Loops

| Loop | Mechanism | Potential |
|------|-----------|-----------|
| Shareable Scores | "My Rizz Score is 85!" | High |
| Before/After | Share rewritten messages | High |
| Streak Sharing | "7 day rizz streak 🔥" | Medium |
| Referral | Invite friends for bonus | High |

### 9.3 Key Metrics

| Metric | Target |
|--------|--------|
| DAU/MAU | >40% |
| Day 1 retention | >60% |
| Day 7 retention | >30% |
| Day 30 retention | >15% |
| Free → Paid conversion | >5% |

### 9.4 Channels

| Channel | Priority | Expected ROI |
|---------|----------|--------------|
| TikTok/Reels | High | Viral potential |
| Reddit | High | Targeted, high intent |
| Dating Discord | High | Perfect audience |
| Influencers | Medium | Trust, reach |
| ASO | Medium | Organic discovery |

---

## 10. Risks & Mitigation

### 10.1 Identified Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| **AI Quality** | High | Medium | Human review, user feedback loop |
| **Privacy Concerns** | High | High | Clear policies, on-device processing option |
| **Trust/Manipulation** | High | Medium | Frame as confidence builder, not manipulation |
| **Competition** | Medium | High | Fast execution, unique features |
| **API Costs** | High | Medium | NVIDIA NIM for free tier, smart routing |
| **App Store Rejection** | Medium | Low | Clear content policies, age rating |
| **User Retention** | High | High | Streaks, gamification, personalization |

### 10.2 Privacy-First Approach

1. **No chat storage** - Analysis happens in-memory, deleted after
2. **Transparent** - "We don't see/store your messages"
3. **On-device** - Future: process locally on device
4. **Anonymized analytics** - Don't track personal messages
5. **GDPR/CCPA** - Full compliance from day 1

### 10.3 Ethical Guidelines

- Position as "confidence builder" not "manipulation tool"
- Encourage authentic communication
- Don't generate fake personas
- User retains full control
- Regular ethical reviews

---

## 11. Competitive Landscape

### 11.1 Competitors

| App | Strengths | Weaknesses |
|-----|-----------|-------------|
| **Grammarly** | Established, polished | Not dating-focused |
| **TextFlirt** | Dating focus | Basic AI, limited features |
| **Fiama** | AI dating | New, limited scale |
| **Wingman (AI)** | Concept | Not launched/wide |

### 11.2 Differentiation

1. **Tone variety** - 6 distinct tones (competitors have 2-3)
2. **Strategy mode** - Full conversation guidance
3. **NVIDIA NIM** - Free tier possible (competitors pay for all)
4. **Privacy focus** - No message storage (competitors store)
5. **Gen Z UI** - Modern, dark mode, viral-ready

---

## 12. Next Steps

### Immediate Actions (This Week)

1. [ ] Set up Flutter project with dependencies
2. [ ] Configure Firebase project
3. [ ] Create basic UI mockups
4. [ ] Write initial LLM prompts
5. [ ] Set up backend API skeleton

### Questions to Answer

1. What naming options do you like? (Rizz AI / Wingman AI / Rizzr / Finesse)
2. Do you want to use existing NVIDIA NIM setup for the AI?
3. What's your timeline - launch in 4 weeks?
4. Budget for paid tools/API costs?

---

## 13. Appendix

### A. LLM Prompt Templates

**Rizz Generator:**
```
You are Rizz, a dating and social conversation expert.
Your goal is to help users create authentic, engaging messages.

Guidelines:
- Never use generic pickup lines
- Match the requested tone exactly
- Make it conversational, not performative
- Avoid emojis unless appropriate for tone
- Keep it under 2 sentences for dating apps
- Be specific and personal when possible

Tone definitions:
- Funny: Playful, uses humor, makes them laugh
- Smooth: Confident, flirty, effortless
- Savage: Bold, teasing, high confidence
- Cute: Sweet, innocent, wholesome
- Mysterious: Intriguing, leaves room for curiosity
- Intellectual: Thoughtful, deep, stimulating

Context clues:
- Dating app: Short, hook-focused
- Text: Can be longer, more casual
- Instagram: Visual-aware, story-worthy
- Crush: Personal, specific references
```

### B. Analytics Events

| Event | Description |
|-------|-------------|
| generation_created | User generates message |
| generation_copied | User copies to clipboard |
| generation_shared | User shares externally |
| rewrite_used | User rewrites message |
| analysis_run | User analyzes conversation |
| subscription_upgrade | User purchases premium |
| streak_day | User returns daily |

### C. User Flow Diagrams

```
GENERATE FLOW:
Home → Tone Select → Context Select → Input → Generate → Results → Copy/Share

ANALYZE FLOW:
Home → Paste Chat → Analyze → View Results → Get Reply → Copy

PREMIUM FLOW:
Feature Blocked → Paywall → Subscribe → Unlock → Use
```

---

*Document Version: 1.0*
*Created: 2026-05-04*
*Author: AI Product Strategy*