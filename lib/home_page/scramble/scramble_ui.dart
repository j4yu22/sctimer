import 'package:flutter/material.dart';

class ScrambleUI extends StatelessWidget {
  const ScrambleUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          // Copy icon (left)
          Icon(Icons.copy, size: 20, color: Colors.black87),

          const SizedBox(width: 8),

          // Scramble text (center)
          const Expanded(
            child: Text(
              'scramble text',
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
