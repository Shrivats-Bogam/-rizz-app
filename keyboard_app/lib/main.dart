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
      home: const KeyboardMainScreen(),
    );
  }
}

class KeyboardMainScreen extends StatefulWidget {
  const KeyboardMainScreen({super.key});

  @override
  State<KeyboardMainScreen> createState() => _KeyboardMainScreenState();
}

class _KeyboardMainScreenState extends State<KeyboardMainScreen> {
  final TextEditingController _inputController = TextEditingController();
  List<String> _suggestions = [];
  String _selectedTone = 'funny';
  bool _showKeyboard = true;

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
    _inputController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _getSuggestions();
  }

  Future<void> _getSuggestions() async {
    final text = _inputController.text;
    if (text.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://rizz-backend-gwkk.onrender.com/generate'),
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

  void _insertSuggestion(String text) {
    final currentText = _inputController.text;
    final selection = _inputController.selection;

    String newText;
    int newCursorPos;

    if (selection.isValid && selection.start > 0) {
      newText = currentText.substring(0, selection.start) + text + currentText.substring(selection.end);
      newCursorPos = selection.start + text.length;
    } else {
      newText = currentText + text;
      newCursorPos = newText.length;
    }

    _inputController.text = newText;
    _inputController.selection = TextSelection.collapsed(offset: newCursorPos);
  }

  void _insertEmoji(String emoji) {
    final currentText = _inputController.text;
    final selection = _inputController.selection;

    if (selection.isValid) {
      final newText = currentText.substring(0, selection.start) + emoji + currentText.substring(selection.end);
      _inputController.text = newText;
      _inputController.selection = TextSelection.collapsed(offset: selection.start + emoji.length);
    } else {
      _inputController.text = currentText + emoji;
    }
  }

  void _deleteBackward() {
    final text = _inputController.text;
    final selection = _inputController.selection;

    if (selection.isValid && selection.start > 0) {
      final newText = text.substring(0, selection.start - 1) + text.substring(selection.end);
      _inputController.text = newText;
      _inputController.selection = TextSelection.collapsed(offset: selection.start - 1);
    } else if (text.isNotEmpty) {
      _inputController.text = text.substring(0, text.length - 1);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSuggestionBar(),
            _buildToneSelector(),
            _buildInputField(),
            if (_showKeyboard) _buildKeyboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                          onTap: () => _insertSuggestion(_suggestions[index]),
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
          IconButton(
            icon: Icon(_showKeyboard ? Icons.keyboard_hide : Icons.keyboard, color: const Color(0xFF8B5CF6)),
            onPressed: () => setState(() => _showKeyboard = !_showKeyboard),
          ),
        ],
      ),
    );
  }

  Widget _buildToneSelector() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF1A1A24),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF374151),
                ),
              ),
              child: Center(
                child: Text(
                  tone.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                    fontSize: 12,
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

  Widget _buildInputField() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2D3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _inputController,
            maxLines: 4,
            minLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              hintStyle: TextStyle(color: Color(0xFF6B7280)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF8B5CF6)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _inputController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied! Paste in your chat'), duration: Duration(seconds: 2)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFF121218),
        border: Border(top: BorderSide(color: Color(0xFF2D2D3A))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('😀'), _buildKey('😂'), _buildKey('🥰'),
              _buildKey('🔥'), _buildKey('😏'), _buildKey('😊'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('✨'), _buildKey('💕'), _buildKey('👍'),
              _buildKey('🙌'), _buildKey('💫'), _buildKey('👀'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('🎯'), _buildKey('💯'), _buildKey('🤔'),
              _buildKey('🥺'), _buildKey('😈'), _buildKey('🔮'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionKey('ABC', () {
                // Could switch to full keyboard
              }, flex: 2),
              const SizedBox(width: 4),
              _buildActionKey('🌐', () {
                // Switch language
              }, flex: 1),
              const SizedBox(width: 4),
              _buildActionKey('⌫', _deleteBackward, flex: 1),
              const SizedBox(width: 4),
              _buildActionKey('⏎', () => _insertSuggestion('\n'), flex: 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String emoji) {
    return GestureDetector(
      onTap: () => _insertEmoji(emoji),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  Widget _buildActionKey(String label, VoidCallback onTap, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D3A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
      ),
    );
  }
}