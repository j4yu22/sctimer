import 'package:flutter/material.dart';

class TimeDisplayUI extends StatelessWidget {
  const TimeDisplayUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Takes remaining space between timer and footer
      child: Row(
        children: [
          // Left column for averages
          Container(
            width: 80, // Enough for "00:00.00"
            color: Colors.grey[300],
            padding: const EdgeInsets.all(6),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Averages display', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          // Right side for previous times
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(6),
              child: const Text(
                'Previous times display',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
