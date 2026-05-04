import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const RizzApp());
}

class RizzApp extends StatelessWidget {
  const RizzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rizz AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFFEC4899),
          surface: Color(0xFF1A1A24),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0F),
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1A1A24),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A24),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2D2D3A), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
          ),
          hintStyle: const TextStyle(color: Color(0xFF6B7280)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🔥',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'RIZZ AI',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your AI Wingman',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildFeatureCard(
                context,
                icon: '🎯',
                title: 'Rizz Generator',
                subtitle: 'Generate messages by tone & context',
                color: const Color(0xFF8B5CF6),
                gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RizzGeneratorScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                icon: '✏️',
                title: 'Message Rewriter',
                subtitle: 'Improve your message (3 variations)',
                color: const Color(0xFFEC4899),
                gradient: const [Color(0xFFEC4899), Color(0xFFDB2777)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MessageRewriterScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                icon: '🔍',
                title: 'Conversation Analyzer',
                subtitle: 'Analyze chats & get suggestions',
                color: const Color(0xFF10B981),
                gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyzerScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                icon: '📊',
                title: 'Rizz Tips',
                subtitle: 'Learn dating & social tips',
                color: const Color(0xFFF59E0B),
                gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TipsScreen()),
                ),
              ),
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Powered by Claude Code + NVIDIA NIM',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withOpacity(0.2),
              gradient[1].withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: gradient[0].withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: gradient[0].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios, color: gradient[0], size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TIPS SCREEN ====================

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'title': '👀 The Eye Contact Rule',
        'content': 'In person, hold eye contact for 2-3 seconds at a time. Too short seems fake, too long feels intense. In texts, match their response time.'
      },
      {
        'title': '⏰ The 50% Rule',
        'content': 'Don\'t text more than 50% of the total messages in a conversation. Let them contribute too - it shows you\'re not desperate.'
      },
      {
        'title': '❓ The Question Game',
        'content': 'End your texts with questions to keep conversation flowing. "Had fun today!" vs "Had fun today! What was your favorite part?" Big difference.'
      },
      {
        'title': '🎭 Mystery Matters',
        'content': 'Share 70% about yourself, ask 30%. Keep some things to talk about on future dates. Don\'t reveal everything at once.'
      },
      {
        'title': '✨ Quality Over Quantity',
        'content': 'One well-thought message beats 10 rushed ones. Take time to craft a response that shows you\'re genuinely interested.'
      },
      {
        'title': '😏 The Bold Move',
        'content': 'If you want something, ask. "Want to grab drinks Friday?" is more attractive than being vague and hoping they get the hint.'
      },
      {
        'title': '💬 Text Tone',
        'content': 'Match their energy. If they use emojis, use some back. If they\'re short, be brief. Mirror their texting style.'
      },
      {
        'title': '🛑 The Pullback',
        'content': 'After 2-3 good exchanges, end the conversation on a high note. "Got to run, talk soon!" keeps them wanting more.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('💡 Rizz Tips'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tip['content']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==================== RIZZ GENERATOR SCREEN ====================

class RizzGeneratorScreen extends StatefulWidget {
  const RizzGeneratorScreen({super.key});

  @override
  State<RizzGeneratorScreen> createState() => _RizzGeneratorScreenState();
}

class _RizzGeneratorScreenState extends State<RizzGeneratorScreen> {
  String selectedTone = 'funny';
  String selectedContext = 'dating_app';
  final TextEditingController _detailsController = TextEditingController();
  List<String> results = [];
  bool isLoading = false;

  final List<String> tones = ['funny', 'smooth', 'savage', 'cute', 'mysterious', 'intellectual'];
  final List<String> contexts = ['crush', 'dating_app', 'text', 'instagram'];

  final Map<String, Map<String, List<String>>> _sampleResponses = {
    'funny': {
      'dating_app': [
        "Okay I'm officially curious - what kind of trouble are you usually up to on Friday nights? 😏",
        "Not gonna lie, I've been trying to be clever for 20 minutes. Just be impressed please. 🤡",
        "You seem like someone who makes life interesting. Prove me right? ✨"
      ],
      'crush': [
        "So I was thinking... if I were a potato, I'd definitely be the loaded kind. What about you? 🥔",
        "I've got a joke about you but I'm too lazy to tell it. Let's go on a date instead 😏",
        "My friend asked why I'm smiling at my phone. I said 'a cute person exists.' That person is you. ☺️"
      ],
      'text': [
        "Fun fact: I've checked my phone 47 times today. 46 were for you. The other was for work. 📱💕",
        "I've run out of smart things to say so I'm just gonna say... hi. Hi. 👋😊",
        "Update: My brain is now 90% thoughts of you. The other 10% is pizza. Close call. 🍕"
      ],
      'instagram': [
        "Not to be dramatic but your story is giving me life. Who taught you?? ✨🔥",
        "This photo deserves way more likes. I'm personally responsible for half of them already. 💕",
        "You ever just look at someone's post and think 'wow, they're really that great'? Yeah. That's me right now. 🥹"
      ]
    },
    'smooth': {
      'dating_app': [
        "I'm usually not one to say this, but I'd love to hear more about you. What makes you light up?",
        "There's something about your profile that caught my attention. Want to find out what?",
        "I don't usually start conversations, but you seem worth the exception."
      ],
      'crush': [
        "I've been wanting to talk to you for a while now. Want to grab coffee sometime?",
        "Honestly? I've been thinking about you. Want to change that to spending time together?",
        "You make nervous look good. Can I take you out and see if the feeling is mutual? 💫"
      ],
      'text': [
        "Hey, I was thinking about you. How's your day going? Hope it's as great as you are.",
        "Just wanted to say you popped into my mind. Anything exciting happening?",
        "I've been meaning to tell you - I really enjoy our conversations. They're the highlight of my day."
      ],
      'instagram': [
        "That photo is incredible. You have great energy - it's hard to look away.",
        "Your style is on point. Seriously impressed every time I see your posts. 🔥",
        "This is the content I come here for. You're always so genuine - love it."
      ]
    },
    'savage': {
      'dating_app': [
        "You seem interesting. Let's see if you can keep up. 😏",
        "Alright, I'll be direct. You're intriguing. What's your angle?",
        "Most people bore me. You haven't yet. That's high praise. 🎯"
      ],
      'crush': [
        "Okay I'll be honest - I've been wanting to talk to you. No more games. Want to grab coffee?",
        "I'm not usually this forward but life's too short. You, me, drinks - when are you free? 🥂",
        "Look, I'm into you. A lot. Before this gets awkward - yes, I said it. Now let's do something about it. 😏"
      ],
      'text': [
        "You've got 3 options: be impressed, be intrigued, or be confused. I'm going for all 3. 🍿",
        "I'm gonna make this simple - I like you. A lot. Any questions? 🤔💕",
        "Normally I'd play it cool but I'm 0 for 12 on that. So here we are. 🙃"
      ],
      'instagram': [
        "This is the energy I come here for. Real ones know. 🔥",
        "No cap, this was the best thing I'll see today. You're killing it. 💯",
        "The confidence! The vibe! The everything! I'm genuinely impressed. 😍"
      ]
    },
    'cute': {
      'dating_app': [
        "Hi! I think you seem really sweet and I'd love to get to know you better 💕",
        "Your profile made me smile! Want to make an even better connection?",
        "Hey there! You seem really kind. Would you want to chat? 🌸"
      ],
      'crush': [
        "Hey! I've been wanting to talk to you, hope I'm not being too forward 😊",
        "This is super nerve-wracking but... I think you're really cool! Want to hang out sometime? 🥺",
        "Okay this took me 47 attempts to send but... hi! I think you're amazing! 💖"
      ],
      'text': [
        "Hiii! Just wanted to say you made my day brighter ☀️",
        "Hey you! Thinking of you right now... in a very cute way 💕",
        "Okay tiny confession: I smiled when I saw your message. Now I'm smiling while typing this. Send help. Or cookies. 🍪😊"
      ],
      'instagram': [
        "This is the cutest thing I've seen today! You look so happy! 🥺💖",
        "UGHHH YOU'RE SO CUTE!! This made my entire afternoon!! 🥹💕",
        "The cuteness is too real!! I can't handle this!! Someone save me!! 😫💖"
      ]
    },
    'mysterious': {
      'dating_app': [
        "I have a feeling you'd be interesting to talk to... care to find out?",
        "There's something different about you. Can't quite put my finger on it. Let's talk?",
        "I'll be honest - I'm curious about you. That's rare for me. Want to change that?"
      ],
      'crush': [
        "There's something about you I can't quite figure out. I'd love to try.",
        "You intrigue me. You're more like a mystery novel. I want to read the whole series. 📖✨",
        "I don't usually do this, but something tells me you're worth breaking my rules for."
      ],
      'text': [
        "You know what? I've got a secret. Maybe I'll tell you sometime... 🤫",
        "I've been thinking about you. More than usual. That's saying something. 🤔",
        "There's a reason I keep texting you. Maybe one day I'll explain. Or maybe I won't. 💫"
      ],
      'instagram': [
        "Interesting choice... I respect it. 🎭",
        "This has layers. I appreciate that. Very you. 🔮",
        "The mystery continues... I'm here for it. ✨"
      ]
    },
    'intellectual': {
      'dating_app': [
        "I'd love to hear your perspective on something. What's something you're passionate about?",
        "Your profile suggests you have depth. I'd love to explore that. What makes you curious?",
        "I'm drawn to substance over style. You seem to have both. Let's talk ideas?"
      ],
      'crush': [
        "I've noticed you're quite thoughtful. I'd love to explore that more with you.",
        "There's an intelligence in how you carry yourself. I'd love to understand it better.",
        "I'd love to have a real conversation with you. Your thoughts on anything?"
      ],
      'text': [
        "I've been meaning to ask - what's your take on that new thing everyone's talking about?",
        "Your mind is your most attractive feature. What are you currently deep in thought about? 🧠💫",
        "I've been wanting to have a proper conversation with you. The real stuff. Are you up for it?"
      ],
      'instagram': [
        "This is giving so much depth. Love the substance behind the aesthetic. 🧠",
        "Your posts always make me think. That's rare. Thank you for that. 💡",
        "The way you express yourself is genuinely interesting. You have a unique perspective. 👀"
      ]
    },
  };

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Rizz Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF8B5CF6)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select your vibe and context, then generate perfect messages!',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Select Tone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tones.map((tone) => _buildChip(tone, selectedTone == tone, () => setState(() => selectedTone = tone))).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Select Context', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: contexts.map((ctx) => _buildChip(ctx, selectedContext == ctx, () => setState(() => selectedContext = ctx))).toList(),
            ),
            const SizedBox(height: 24),
            const Text('What do you want to say?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Example: I want to ask them out for coffee...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _generateRizz,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🎯 Generate Rizz'),
                        ],
                      ),
              ),
            ),
            if (results.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 20),
                  const SizedBox(width: 8),
                  const Text('Generated Messages:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 12),
              ...results.asMap().entries.map((entry) => _buildResultCard(entry.value, entry.key + 1)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF8B5CF6) : const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF8B5CF6) : const Color(0xFF374151),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String message, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('#$index', style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton('📋 Copy', () {
                  Clipboard.setData(ClipboardData(text: message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!'), duration: Duration(seconds: 1)),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton('🔄 Try Another', () {
                  _generateNew();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _generateRizz() {
    if (_detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe what you want to say')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      results = [];
    });

    // Try backend first, then use samples
    _callBackend();
  }

  Future<void> _callBackend() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/generate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tone': selectedTone,
          'context': selectedContext,
          'details': _detailsController.text,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          results = [data['message'], _getAnotherSample()];
          isLoading = false;
        });
      }
    } catch (e) {
      // Use samples
      _useSamples();
    }
  }

  void _useSamples() {
    final samples = _sampleResponses[selectedTone]?[selectedContext] ?? [];
    if (samples.isNotEmpty) {
      setState(() {
        results = [samples[0], samples.length > 1 ? samples[1] : samples[0]];
        isLoading = false;
      });
    } else {
      setState(() {
        results = ["Hey there! 👋 I've been wanting to talk to you. What have you been up to?"];
        isLoading = false;
      });
    }
  }

  String _getAnotherSample() {
    final samples = _sampleResponses[selectedTone]?[selectedContext] ?? [];
    if (samples.length > 1) {
      return samples[1];
    }
    return samples.isNotEmpty ? samples[0] : "Can't wait to hear your story! ☕";
  }

  void _generateNew() {
    setState(() {
      results = [results[0], _getAnotherSample()];
    });
  }
}

// ==================== MESSAGE REWRITER SCREEN ====================

class MessageRewriterScreen extends StatefulWidget {
  const MessageRewriterScreen({super.key});

  @override
  State<MessageRewriterScreen> createState() => _MessageRewriterScreenState();
}

class _MessageRewriterScreenState extends State<MessageRewriterScreen> {
  final TextEditingController _messageController = TextEditingController();
  Map<String, String> variations = {};
  bool isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✏️ Message Rewriter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEC4899).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEC4899).withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tips_and_updates, color: Color(0xFFEC4899)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter your message and get 3 improved versions!',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Enter your message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _rewriteMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC4899),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('✨ Rewrite Message'),
                        ],
                      ),
              ),
            ),
            if (variations.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildVariationCard('🛡️ Safe', variations['safe'] ?? '', const Color(0xFF10B981)),
              const SizedBox(height: 12),
              _buildVariationCard('🔥 Bold', variations['bold'] ?? '', const Color(0xFFEF4444)),
              const SizedBox(height: 12),
              _buildVariationCard('😏 Playful', variations['playful'] ?? '', const Color(0xFFEC4899)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVariationCard(String title, String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                color: color,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied!'), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }

  Future<void> _rewriteMessage() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message to rewrite')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      variations = {};
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/rewrite'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': _messageController.text}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          variations = Map<String, String>.from(data['variations'] ?? {});
        });
      }
    } catch (e) {
      // Fallback
      setState(() {
        variations = {
          'safe': 'I really enjoyed talking to you and would love to continue getting to know you better.',
          'bold': "Alright, I'm not gonna lie - I think you're incredible. Let's make this happen. 😏",
          'playful': "Okay you win - I can't stop thinking about our conversation. Guilty as charged! 😅",
        };
      });
    } finally {
      setState(() => isLoading = false);
    }
  }
}

// ==================== ANALYZER SCREEN ====================

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({super.key});

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  final TextEditingController _chatController = TextEditingController();
  Map<String, dynamic> analysis = {};
  bool isLoading = false;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Conversation Analyzer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.psychology, color: Color(0xFF10B981)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paste your conversation and get AI-powered analysis!',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Paste your conversation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
              controller: _chatController,
              maxLines: 10,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Paste your chat here...\n\nExample:\nThem: Hey! How was your weekend?\nYou: It was great! Went hiking.\nThem: Nice! I love hiking!',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _analyzeChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🔍 Analyze Chat'),
                        ],
                      ),
              ),
            ),
            if (analysis.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildAnalysisResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResult() {
    final interestLevel = (analysis['interest_level'] ?? 0.5).toDouble();
    final vibe = analysis['vibe'] ?? '💬 Conversation';
    final redFlags = (analysis['red_flags'] as List?) ?? [];
    final suggestion = analysis['suggestion'] ?? '';

    final interestColor = interestLevel > 0.7
        ? const Color(0xFF10B981)
        : interestLevel > 0.4
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: interestColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(vibe, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: interestColor)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: interestColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${(interestLevel * 100).toInt()}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: interestColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Interest Level', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: interestLevel,
              backgroundColor: const Color(0xFF374151),
              valueColor: AlwaysStoppedAnimation<Color>(interestColor),
              minHeight: 8,
            ),
),
          if (redFlags.isNotEmpty) _buildRedFlags(redFlags),
          if (suggestion.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFF8B5CF6), size: 20),
                const SizedBox(width: 8),
                const Text('💡 Best Reply', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
              ),
              child: Text(suggestion, style: const TextStyle(color: Colors.white, height: 1.4)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: suggestion));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied!'), duration: Duration(seconds: 1)),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy Suggestion'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF8B5CF6),
                  side: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRedFlags(List redFlags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Row(
          children: [
            Icon(Icons.warning_amber, color: Color(0xFFEF4444), size: 20),
            SizedBox(width: 8),
            Text('Red Flags', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 8),
        ...redFlags.map((flag) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: Color(0xFFEF4444))),
              Expanded(
                child: Text(flag.toString(), style: const TextStyle(color: Color(0xFF9CA3AF))),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Future<void> _analyzeChat() async {
    if (_chatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste a conversation to analyze')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      analysis = {};
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'chat': _chatController.text}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          analysis = data;
        });
      }
    } catch (e) {
      // Smart fallback analysis
      final chat = _chatController.text.toLowerCase();
      final lines = chat.split('\n');
      
      int theirMessages = 0;
      int yourMessages = 0;
      
      for (var line in lines) {
        if (line.trim().startsWith('You:') || line.trim().startsWith('you:')) {
          yourMessages++;
        } else if (line.trim().isNotEmpty) {
          theirMessages++;
        }
      }
      
      final isGood = theirMessages > 0 && yourMessages <= theirMessages * 1.5;
      
      setState(() {
        analysis = {
          'vibe': isGood ? "💬 They seem interested! 🎉" : "🤔 Neutral - keep trying",
          'interest_level': isGood ? 0.75 : 0.45,
          'red_flags': [
            if (yourMessages > theirMessages * 2) "You're sending too many messages - wait for them to respond",
            if (chat.contains('?') == false && !chat.contains('what') && !chat.contains('how')) "Not asking questions - try being more curious about them",
          ],
          'suggestion': isGood
              ? "Hey! So I was thinking - there's this new coffee place that just opened. You seem like someone who'd appreciate good coffee. Worth checking out sometime? ☕"
              : "Keep the conversation balanced. Ask open-ended questions and match their energy before escalating.",
        };
      });
    } finally {
      setState(() => isLoading = false);
    }
  }
}