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
            width: 80,
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
                        print(
                          'TimeDisplayUI: Update triggered for sessionId = $sessionId',
                        );
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: DatabaseHelper.instance.getSolves(
                            sessionId ?? 0,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              print('TimeDisplayUI: Loading solves');
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              print(
                                'TimeDisplayUI: Error fetching solves: ${snapshot.error}',
                              );
                              return const Text(
                                'Error loading times',
                                style: TextStyle(fontSize: 12),
                              );
                            }
                            final solves = snapshot.data ?? [];
                            print(
                              'TimeDisplayUI: Fetched ${solves.length} solves for sessionId = $sessionId',
                            );
                            final displayList = List.generate(5, (index) {
                              if (index < solves.length) {
                                final solve = solves[index];
                                final time = solve['solve_time'] as int;
                                final isDnf = solve['is_dnf'] == 1;
                                final plusTwo = solve['plus_two'] as int;
                                final seconds = (time / 1000).floor();
                                final ms = (time % 1000) ~/ 10;
                                var timeString =
                                    '$seconds.${ms.toString().padLeft(2, '0')}s';
                                if (isDnf) timeString = 'DNF';
                                if (plusTwo > 0) timeString += ' (+2)';
                                return timeString;
                              }
                              return 'N/A';
                            });
                            return ListView.builder(
                              itemCount: displayList.length,
                              itemBuilder:
                                  (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      displayList[index],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
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
