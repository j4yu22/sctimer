import 'package:flutter/material.dart';

class TimeDisplayUI extends StatelessWidget {
  const TimeDisplayUI({super.key});

  // Define the adjustable height here (could later be passed from settings)
  final double displayHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: displayHeight, // Unified height for both panels
      child: Row(
        children: [
          // Left column for averages
          Container(
            width: 80,
            color: Colors.grey[300],
            padding: const EdgeInsets.all(6),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Average', style: TextStyle(fontSize: 12))],
            ),
          ),

          // Right side for previous times
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(6),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Previous Times', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
