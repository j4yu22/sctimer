import 'package:flutter/material.dart';
import 'scramble_logic.dart';
import 'package:flutter/services.dart';

class ScrambleUI extends StatefulWidget {
  const ScrambleUI({super.key});

  @override
  State<ScrambleUI> createState() => ScrambleUIWidget();
}

class ScrambleUIWidget extends State<ScrambleUI> {
  late String _scramble;

  String getNewScramble() {
    return getRandomScramble();
  }

  @override
  void initState() {
    super.initState();
    _scramble = getRandomScramble();
    print('[ScrambleUI] Initial scramble: $_scramble');
  }

  void refreshScramble() {
    print('[ScrambleUI] refreshScramble() was called');
    setState(() {
      _scramble = getRandomScramble();
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _scramble));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          // Copy icon (left)
          GestureDetector(
            onTap: _copyToClipboard,
            child: const Icon(Icons.copy, size: 20, color: Colors.black87),
          ),

          const SizedBox(width: 8),

          // Scramble text (center)
          Expanded(
            child: Center(
              child: Text(
                _scramble,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          // Refresh icon (right)
          IconButton(
            icon: const Icon(Icons.refresh, size: 20, color: Colors.black87),
            onPressed: () {
              setState(() {
                _scramble = getRandomScramble();
              });
            },
          ),
        ],
      ),
    );
  }
}
