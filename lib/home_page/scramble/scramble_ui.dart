import 'package:flutter/material.dart';
import 'scramble_logic.dart';

class ScrambleUI extends StatefulWidget {
  const ScrambleUI({super.key});

  @override
  State<ScrambleUI> createState() => ScrambleUIWidget();
}

class ScrambleUIWidget extends State<ScrambleUI> {
  late final String _scramble = GetNewScramble();

  String GetNewScramble() {
    return "";
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
          Icon(Icons.copy, size: 20, color: Colors.black87),

          const SizedBox(width: 8),

          // Scramble text (center)
          Expanded(
            child: Text(
              _scramble,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.visible,
            ),
          ),

          // Refresh icon (right)
          Icon(Icons.refresh, size: 20, color: Colors.black87),
        ],
      ),
    );
  }
}
