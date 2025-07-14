import 'package:flutter/material.dart';
import '../../data/database_helper.dart';

class TimeDisplayUI extends StatelessWidget {
  final int? sessionId;
  final ValueNotifier<int> updateNotifier;

  const TimeDisplayUI({
    super.key,
    required this.sessionId,
    required this.updateNotifier,
  });

  @override
  Widget build(BuildContext context) {
    print('TimeDisplayUI: Building with sessionId = $sessionId');
    return SizedBox(
      height: 150.0,
      child: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey[300],
            padding: const EdgeInsets.all(6),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Average', style: TextStyle(fontSize: 12))],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: updateNotifier,
                      builder: (context, _, __) {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: DatabaseHelper.instance.getSolves(
                            sessionId ?? 0,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error loading times',
                                style: TextStyle(fontSize: 12),
                              );
                            }
                            final solves = snapshot.data ?? [];
                            if (solves.isEmpty) {
                              return const Text(
                                'No solves yet.',
                                style: TextStyle(fontSize: 12),
                              );
                            }
                            return ListView.builder(
                              itemCount: solves.length,
                              itemBuilder: (context, index) {
                                final solve = solves[index];
                                final milliseconds = solve['solve_time'] as int;
                                final seconds = (milliseconds / 1000).floor();
                                final ms = (milliseconds % 1000) ~/ 10;
                                final timeString =
                                    '$seconds.${ms.toString().padLeft(2, '0')}';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    timeString,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
