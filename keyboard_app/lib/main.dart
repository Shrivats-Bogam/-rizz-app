import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const RizzKeyboardApp());
}

class RizzKeyboardApp extends StatelessWidget {
  const RizzKeyboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rizz Keyboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFFEC4899),
          surface: Color(0xFF1A1A24),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LauncherScreen(),
        '/keyboard': (context) => const KeyboardMainScreen(),
      },
      builder: (context, child) {
        // If we are a keyboard, we want to route to /keyboard immediately.
        // We can detect this by checking if we are embedded. But for simplicity
        // in Flutter view embedded within an InputMethodService, we can just use
        // a mechanism or route. The easiest is to just have the initial route be
        // controlled or just use a default layout. Wait, since Android embeds it,
        // it will just launch '/'. Let's actually check if it's the keyboard service.
        // For now, we'll leave routing and maybe set a transparent background for keyboard.
        return child!;
      },
    );
  }
}

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rizz Keyboard Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '1. Enable Rizz Keyboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Open input method settings
                const MethodChannel('rizz_keyboard').invokeMethod('openSettings');
              },
              child: const Text('Open Settings'),
            ),
            const SizedBox(height: 24),
            const Text(
              '2. Select Rizz Keyboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Tap the keyboard icon in the bottom right of your screen when typing to select Rizz Keyboard.'),
            const SizedBox(height: 24),
            const Text(
              '3. Test it out',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Tap here to type...',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/keyboard');
              },
              child: const Text('Preview Keyboard UI'),
            )
          ],
        ),
      ),
    );
  }
}

class KeyboardMainScreen extends StatefulWidget {
  const KeyboardMainScreen({super.key});

  @override
  State<KeyboardMainScreen> createState() => _KeyboardMainScreenState();
}

class _KeyboardMainScreenState extends State<KeyboardMainScreen> {
  String _currentTextContext = '';
  List<String> _suggestions = [];
  String _selectedTone = 'funny';
  bool _showKeyboard = true;
  bool _isShifted = false;
  bool _showSymbols = false;

  static const MethodChannel _channel = MethodChannel('rizz_keyboard');

  final List<String> _tones = ['funny', 'smooth', 'savage', 'cute', 'mysterious'];
  final List<Map<String, String>> _quickReplies = [
    {'text': 'Sounds good! 😊', 'tone': 'cute'},
    {'text': 'Lol nice 😏', 'tone': 'funny'},
    {'text': 'For sure 💫', 'tone': 'smooth'},
    {'text': 'I appreciate it 💕', 'tone': 'cute'},
    {'text': 'Tell me more 🔥', 'tone': 'savage'},
    {'text': 'Interesting... 🤔', 'tone': 'mysterious'},
  ];

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'updateTextContext':
        final text = call.arguments['text'] as String?;
        if (text != null && text != _currentTextContext) {
          setState(() {
            _currentTextContext = text;
          });
          _getSuggestions();
        }
        break;
    }
  }

  Future<void> _getSuggestions() async {
    final text = _currentTextContext;
    if (text.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/generate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tone': _selectedTone,
          'context': 'text',
          'details': text.length > 50 ? text.substring(text.length - 50) : text,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _suggestions = [data['message'], _getQuickReply()];
        });
      }
    } catch (e) {
      setState(() {
        _suggestions = _getFallbackSuggestions();
      });
    }
  }

  String _getQuickReply() {
    final reply = _quickReplies.firstWhere(
      (r) => r['tone'] == _selectedTone,
      orElse: () => _quickReplies.first,
    );
    return reply['text']!;
  }

  List<String> _getFallbackSuggestions() {
    final Map<String, List<String>> fallbacks = {
      'funny': ["Haha 😂", "That's awesome! 😄", "Lolol 🔥"],
      'smooth': ["Absolutely 💫", "I'm into it ✨", "Sounds perfect 👌"],
      'savage': ["Can't lie, that's fire 🔥", "Lowkey impressed 😏", "You win 👑"],
      'cute': ["Aww that's sweet 💕", "You're adorable 🥺", "I love that ☺️"],
      'mysterious': ["Interesting... 🤔", "Now I'm curious 🔮", "Care to explain? 🎭"],
    };
    return fallbacks[_selectedTone] ?? ["Nice! 👍", "Okay 👍", "Sure 👍"];
  }

  void _insertText(String text) {
    _channel.invokeMethod('insertText', {'text': text});
    if (_isShifted) {
      setState(() {
        _isShifted = false;
      });
    }
  }

  void _deleteBackward() {
    _channel.invokeMethod('deleteBackward');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildSuggestionBar(),
          _buildToneSelector(),
          if (_showKeyboard) _buildKeyboard(),
        ],
      ),
    );
  }

  Widget _buildSuggestionBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A24),
        border: Border(bottom: BorderSide(color: Color(0xFF2D2D3A))),
      ),
      child: Row(
        children: [
          const Text('🤖', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: _suggestions.isEmpty
                ? const Text('Type to get AI suggestions...', style: TextStyle(color: Color(0xFF6B7280)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _insertText(_suggestions[index] + " "),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _suggestions[index].length > 25
                                  ? '${_suggestions[index].substring(0, 25)}...'
                                  : _suggestions[index],
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToneSelector() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFF1A1A24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tones.length,
        itemBuilder: (context, index) {
          final tone = _tones[index];
          final isSelected = _selectedTone == tone;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTone = tone;
                _suggestions = _getFallbackSuggestions();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF2D2D3A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  tone.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyboard() {
    if (_showSymbols) {
      return _buildSymbolKeyboard();
    }
    return _buildAlphaKeyboard();
  }

  Widget _buildAlphaKeyboard() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0F),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildKey('q'), _buildKey('w'), _buildKey('e'), _buildKey('r'), _buildKey('t'),
              _buildKey('y'), _buildKey('u'), _buildKey('i'), _buildKey('o'), _buildKey('p'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Spacer(flex: 1),
              _buildKey('a'), _buildKey('s'), _buildKey('d'), _buildKey('f'), _buildKey('g'),
              _buildKey('h'), _buildKey('j'), _buildKey('k'), _buildKey('l'),
              const Spacer(flex: 1),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildActionKey(_isShifted ? '⬆' : '⇧', () {
                setState(() => _isShifted = !_isShifted);
              }, flex: 3),
              _buildKey('z'), _buildKey('x'), _buildKey('c'), _buildKey('v'),
              _buildKey('b'), _buildKey('n'), _buildKey('m'),
              _buildActionKey('⌫', _deleteBackward, flex: 3),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildActionKey('?123', () {
                setState(() => _showSymbols = true);
              }, flex: 3),
              _buildActionKey(',', () => _insertText(','), flex: 2),
              _buildActionKey('space', () => _insertText(' '), flex: 10),
              _buildActionKey('.', () => _insertText('.'), flex: 2),
              _buildActionKey('⏎', () => _insertText('\n'), flex: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolKeyboard() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0F),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildKey('1'), _buildKey('2'), _buildKey('3'), _buildKey('4'), _buildKey('5'),
              _buildKey('6'), _buildKey('7'), _buildKey('8'), _buildKey('9'), _buildKey('0'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildKey('@'), _buildKey('#'), _buildKey('\$'), _buildKey('_'), _buildKey('&'),
              _buildKey('-'), _buildKey('+'), _buildKey('('), _buildKey(')'), _buildKey('/'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildActionKey('=\\<', () {}, flex: 3),
              _buildKey('*'), _buildKey('"'), _buildKey('\''), _buildKey(':'),
              _buildKey(';'), _buildKey('!'), _buildKey('?'),
              _buildActionKey('⌫', _deleteBackward, flex: 3),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildActionKey('ABC', () {
                setState(() => _showSymbols = false);
              }, flex: 3),
              _buildActionKey(',', () => _insertText(','), flex: 2),
              _buildActionKey('space', () => _insertText(' '), flex: 10),
              _buildActionKey('.', () => _insertText('.'), flex: 2),
              _buildActionKey('⏎', () => _insertText('\n'), flex: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label) {
    final displayLabel = _isShifted ? label.toUpperCase() : label;
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _insertText(displayLabel),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D3A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(displayLabel, style: const TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(String label, VoidCallback onTap, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A24),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
