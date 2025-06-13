import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'dart:async';

// This file provides examples of inserting and retrieving data from the cube timer database.
// Use these functions as templates in your app (e.g., main.dart or timer_logic.dart).
// Ensure DatabaseHelper is imported and instantiated before calling these functions.
// Integration notes are included to guide usage in your multi-session Flutter app.

class DatabaseExamples {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // INSERT EXAMPLES

  /// Inserts a new puzzle type (e.g., "Pyraminx").
  /// Context: Use when adding a new puzzle type, typically during app setup or when a user
  /// adds a custom puzzle. Called in main.dart's initState or a settings screen.
  /// Integration:
  /// - Call in _loadSessions or a UI button handler.
  /// - Ensure puzzle_id is unique to avoid conflicts (ConflictAlgorithm.replace overwrites).
  /// - After insertion, refresh puzzles in dropdown (e.g., call getPuzzles and update state).
  Future<void> insertPuzzleExample() async {
    try {
      await _dbHelper.insertPuzzle({'puzzle_id': 3, 'puzzle_name': 'Pyraminx'});
      print('Puzzle inserted successfully');
    } catch (e) {
      print('Error inserting puzzle: $e');
    }
  }

  /// Inserts a new session for a puzzle (e.g., "Eve's 3x3").
  /// Context: Use when a user creates a new session via the UI (e.g., "Add Session" dialog).
  /// Integration:
  /// - Call in main.dart's _addSession after getting user input (session_name, puzzle_id).
  /// - puzzle_id must exist in puzzle table (foreign key constraint).
  /// - session_name must be unique (enforced by UNIQUE constraint).
  /// - Refresh sessions dropdown after insertion (call getSessions and setState).
  Future<void> insertSessionExample() async {
    try {
      await _dbHelper.insertSession({
        'puzzle_id':
            1, // Must match an existing puzzle_id (e.g., 1 for 3x3 Cube)
        'session_name': 'Eve\'s 3x3',
      });
      print('Session inserted successfully');
    } catch (e) {
      print('Error inserting session: $e');
    }
  }

  /// Inserts a solve for a session with optional tags.
  /// Context: Use when the timer stops (e.g., in TimerLogic's stop method) to save a solve.
  /// Integration:
  /// - Call in timer_logic.dart's stop method, passing _milliseconds and session_id.
  /// - session_id must exist (foreign key constraint).
  /// - Use user inputs (scramble, is_dnf, plus_two, tags) from main.dart's UI (e.g., TextField, Checkbox).
  /// - solve_number should increment per session (use getSolveCount).
  /// - Refresh solve history after insertion (call getSolves and setState in main.dart).
  Future<void> insertSolveWithTagsExample(
    int sessionId,
    int milliseconds,
  ) async {
    try {
      final solveNumber = (await _dbHelper.getSolveCount(sessionId)) + 1;
      final solveId = await _dbHelper.insertSolve({
        'solve_number': solveNumber,
        'solve_time': milliseconds,
        'is_dnf': 0,
        'plus_two': 0,
        'scramble': 'U R F L B',
        'comment': 'Smooth solve',
        'date_time': DateTime.now().toIso8601String(),
        'session_id': sessionId,
        'reconstruction': 'U R F',
      });
      // Insert tags
      final tagId1 = await _dbHelper.insertTag({'tag_name': 'PB'});
      await _dbHelper.insertSolveTag(solveId, tagId1);
      print('Solve and tags inserted successfully');
    } catch (e) {
      print('Error inserting solve: $e');
    }
  }

  /// Inserts a tag (e.g., "Good").
  /// Context: Use when adding a new tag, either automatically (e.g., for DNF) or via user input.
  /// Integration:
  /// - Call before insertSolveTag to get tag_id.
  /// - Typically used in timer_logic.dart's stop method or a tag management UI.
  /// - tag_name should be unique (ConflictAlgorithm.replace overwrites duplicates).
  /// - No UI refresh needed unless displaying tags in a dropdown.
  Future<void> insertTagExample() async {
    try {
      await _dbHelper.insertTag({'tag_name': 'Good'});
      print('Tag inserted successfully');
    } catch (e) {
      print('Error inserting tag: $e');
    }
  }

  /// Links a solve to a tag (many-to-many relationship).
  /// Context: Use after inserting a solve and tag to associate them.
  /// Integration:
  /// - Call in timer_logic.dart's stop method after insertSolve and insertTag.
  /// - solve_id and tag_id must exist (foreign key constraints).
  /// - No UI refresh needed unless tags are displayed in history (handled by getTagsForSolve).
  Future<void> insertSolveTagExample(int solveId, int tagId) async {
    try {
      await _dbHelper.insertSolveTag(solveId, tagId);
      print('Solve-tag link inserted successfully');
    } catch (e) {
      print('Error inserting solve-tag: $e');
    }
  }

  // GET EXAMPLES

  /// Retrieves all puzzles.
  /// Context: Use to populate a puzzle dropdown (e.g., when adding a session).
  /// Integration:
  /// - Call in main.dart's _addSession dialog to display puzzles (e.g., 3x3, 2x2).
  /// - Use in a FutureBuilder or setState to update UI.
  /// - Returns List<Map> with puzzle_id and puzzle_name.
  Future<void> getPuzzlesExample() async {
    try {
      final puzzles = await _dbHelper.getPuzzles();
      print('Puzzles: $puzzles');
    } catch (e) {
      print('Error getting puzzles: $e');
    }
  }

  /// Retrieves all sessions.
  /// Context: Use to populate the session dropdown in the main UI.
  /// Integration:
  /// - Call in main.dart's _loadSessions or after insertSession.
  /// - Use in a DropdownButton with setState to update _selectedSessionId.
  /// - Returns List<Map> with session_id, puzzle_id, session_name.
  Future<void> getSessionsExample() async {
    try {
      final sessions = await _dbHelper.getSessions();
      print('Sessions: $sessions');
    } catch (e) {
      print('Error getting sessions: $e');
    }
  }

  /// Retrieves solves for a session.
  /// Context: Use to display solve history for the selected session.
  /// Integration:
  /// - Call in main.dart's FutureBuilder for solve history.
  /// - Pass _selectedSessionId from the dropdown.
  /// - Use in a ListView.builder to display solves.
  /// - Returns List<Map> with all solve fields (solve_id, solve_time, etc.).
  Future<void> getSolvesExample(int sessionId) async {
    try {
      final solves = await _dbHelper.getSolves(sessionId);
      print('Solves for session $sessionId: $solves');
    } catch (e) {
      print('Error getting solves: $e');
    }
  }

  /// Retrieves the number of solves for a session.
  /// Context: Use to calculate the next solve_number when inserting a solve.
  /// Integration:
  /// - Call in timer_logic.dart's stop method before insertSolve.
  /// - Pass session_id from TimerLogic's constructor.
  /// - Returns an integer (e.g., 5 if 5 solves exist).
  Future<void> getSolveCountExample(int sessionId) async {
    try {
      final count = await _dbHelper.getSolveCount(sessionId);
      print('Solve count for session $sessionId: $count');
    } catch (e) {
      print('Error getting solve count: $e');
    }
  }

  /// Retrieves all tags.
  /// Context: Use to populate a tag selection UI (e.g., a tag dropdown or chips).
  /// Integration:
  /// - Call in a settings screen or when allowing users to select tags for a solve.
  /// - Use in a FutureBuilder or setState to update UI.
  /// - Returns List<Map> with tag_id and tag_name.
  Future<void> getTagsExample() async {
    try {
      final tags = await _dbHelper.getTags();
      print('Tags: $tags');
    } catch (e) {
      print('Error getting tags: $e');
    }
  }

  /// Retrieves tags for a specific solve.
  /// Context: Use to display tags in the solve history (e.g., "PB, DNF").
  /// Integration:
  /// - Call in main.dart's solve history ListView.builder, inside a nested FutureBuilder.
  /// - Pass solve_id from each solve in getSolves.
  /// - Returns List<Map> with tag_id and tag_name for the solve.
  Future<void> getTagsForSolveExample(int solveId) async {
    try {
      final tags = await _dbHelper.getTagsForSolve(solveId);
      print('Tags for solve $solveId: $tags');
    } catch (e) {
      print('Error getting tags for solve: $e');
    }
  }

  // Example usage in a widget (for reference)
  /// This shows how to integrate some examples in a Flutter widget.
  /// Copy relevant parts to main.dart or a custom widget.
  Widget buildExampleWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: insertPuzzleExample,
              child: const Text('Insert Puzzle'),
            ),
            ElevatedButton(
              onPressed: () => insertSolveWithTagsExample(1, 2340),
              child: const Text('Insert Solve'),
            ),
            ElevatedButton(
              onPressed: getSessionsExample,
              child: const Text('Get Sessions'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _dbHelper.getSolves(1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Solves: ${snapshot.data!.length}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
