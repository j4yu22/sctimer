import 'dart:developer';
import 'database_helper.dart';

// DatabaseExamples provides commented examples for using DatabaseHelper functions.
// Each static method demonstrates one function with realistic use cases,
// error handling, and explanations for beginners.
// Use these examples to understand how to integrate DatabaseHelper in your app.
class DatabaseExamples {
  // Example for getPuzzles: Fetch all puzzles for a puzzle dropdown.
  static Future<void> exampleGetPuzzles() async {
    // Purpose: Fetch all puzzles to populate a puzzle selection dropdown in main.dart.
    // Input: None.
    // Output: List<Map<String, dynamic>> where each map has puzzle_id (int) and
    // puzzle_name (String), e.g., [{"puzzle_id": 1, "puzzle_name": "3x3 Cube"}, ...].
    log('Running exampleGetPuzzles...');
    try {
      // Call getPuzzles (async, returns Future, so use await).
      final puzzles = await DatabaseHelper.instance.getPuzzles();

      // Check if puzzles are empty.
      if (puzzles.isEmpty) {
        log('No puzzles found. Check if default data was inserted.');
        return;
      }

      // Print each puzzle (simulates populating a dropdown).
      for (var puzzle in puzzles) {
        final id = puzzle['puzzle_id'] as int;
        final name = puzzle['puzzle_name'] as String;
        log('Puzzle: ID=$id, Name=$name');
      }

      // App integration: Use in main.dart's _loadPuzzlesAndSessions to populate
      // _puzzles for a DropdownButtonFormField.
      // Example: setState(() { _puzzles = puzzles; });
    } catch (e) {
      log('Error fetching puzzles: $e');
      // Handle error in app, e.g., show a SnackBar in main.dart.
    }
  }

  // Example for getSessions: Fetch all sessions for debugging or fallback UI.
  static Future<void> exampleGetSessions() async {
    // Purpose: Fetch all sessions to display a list or debug session data.
    // Input: None.
    // Output: List<Map<String, dynamic>> with session_id (int), puzzle_id (int),
    // session_name (String), scramble_type_id (int), e.g.,
    // [{"session_id": 1, "puzzle_id": 1, "session_name": "Default 3x3", ...}, ...].
    log('Running exampleGetSessions...');
    try {
      final sessions = await DatabaseHelper.instance.getSessions();

      if (sessions.isEmpty) {
        log('No sessions found. Create a session using insertSession.');
        return;
      }

      // Print sessions (simulates displaying in a ListView).
      for (var session in sessions) {
        final id = session['session_id'] as int;
        final name = session['session_name'] as String;
        final puzzleId = session['puzzle_id'] as int;
        final scrambleTypeId = session['scramble_type_id'] as int;
        log(
          'Session: ID=$id, Name=$name, PuzzleID=$puzzleId, ScrambleTypeID=$scrambleTypeId',
        );
      }

      // App integration: Rarely used directly; prefer getSessionsByPuzzle for
      // puzzle-specific sessions in main.dart's session dropdown.
    } catch (e) {
      log('Error fetching sessions: $e');
    }
  }

  // Example for getSessionsByPuzzle: Fetch sessions for a specific puzzle.
  static Future<void> exampleGetSessionsByPuzzle() async {
    // Purpose: Fetch sessions for a puzzle to populate a session dropdown in main.dart.
    // Input: puzzleId (int), e.g., 1 for 3x3 Cube.
    // Output: List<Map<String, dynamic>> with sessions for the puzzle.
    const puzzleId = 1; // Example: 3x3 Cube (from default data).
    log('Running exampleGetSessionsByPuzzle for puzzleId=$puzzleId...');
    try {
      final sessions = await DatabaseHelper.instance.getSessionsByPuzzle(
        puzzleId,
      );

      if (sessions.isEmpty) {
        log(
          'No sessions for puzzleId=$puzzleId. Create one with insertSession.',
        );
        return;
      }

      // Print sessions (simulates updating a DropdownButtonFormField).
      for (var session in sessions) {
        final id = session['session_id'] as int;
        final name = session['session_name'] as String;
        log('Session for puzzle $puzzleId: ID=$id, Name=$name');
      }

      // App integration: Use in main.dart's _loadSessions to update _sessions when
      // _selectedPuzzleId changes. Example:
      // setState(() { _sessions = sessions; _selectedSessionId = sessions.first['session_id']; });
    } catch (e) {
      log('Error fetching sessions for puzzleId=$puzzleId: $e');
    }
  }

  // Example for getScrambleTypesByPuzzle: Fetch scramble types for a specific puzzle.
  // Use case: Populate scramble type dropdown in main.dart's _addSession dialog.
  static Future<void> exampleGetScrambleTypesByPuzzle() async {
    print('\nRunning exampleGetScrambleTypesByPuzzle...');
    // Example puzzle ID: 1 (3x3 Cube)
    const puzzleId = 1;
    try {
      // Fetch scramble types for puzzleId
      final scrambleTypes = await DatabaseHelper.instance
          .getScrambleTypesByPuzzle(puzzleId);

      // scrambleTypes is List<Map<String, dynamic>>, filtered by puzzle_id
      if (scrambleTypes.isEmpty) {
        print('No scramble types found for puzzle ID $puzzleId.');
        return;
      }

      // Print each scramble type (simulates dropdown population)
      print(
        'Found ${scrambleTypes.length} scramble types for puzzle ID $puzzleId:',
      );
      for (var scrambleType in scrambleTypes) {
        final id = scrambleType['scramble_type_id'] as int;
        final name = scrambleType['scramble_type_name'] as String;
        print('Scramble Type ID: $id, Name: $name');
      }

      // App integration: Use in main.dart's _addSession dialog to populate a
      // scramble type dropdown. Ensures scramble types match the selected puzzle.
      // Example in _addSession:
      // DropdownButtonFormField(
      //   items: scrambleTypes.map((type) => DropdownMenuItem(
      //     value: type['scramble_type_id'],
      //     child: Text(type['scramble_type_name']),
      //   )).toList(),
      //   onChanged: (value) => setState(() => _selectedScrambleTypeId = value as int),
      // );
    } catch (e) {
      log('Error fetching scramble types for puzzleId=$puzzleId: $e');
    }
  }

  // Example for getSolves: Fetch solves for a session to display history.
  static Future<void> exampleGetSolves() async {
    // Purpose: Fetch solves for a session to display in a history list or graph.
    // Input: sessionId (int), e.g., 1 for Default 3x3.
    // Output: List<Map<String, dynamic>> with solve_id (int), solve_number (int?),
    // solve_time (int), is_dnf (bool), plus_two (int), scramble (String), etc.
    const sessionId = 1; // Example: Default 3x3 session.
    log('Running exampleGetSolves for sessionId=$sessionId...');
    try {
      final solves = await DatabaseHelper.instance.getSolves(sessionId);

      if (solves.isEmpty) {
        log(
          'No solves for sessionId=$sessionId. Add solves via timer_logic.dart.',
        );
        return;
      }

      // Print solves (simulates ListView in main.dart).
      for (var solve in solves) {
        final id = solve['solve_id'] as int;
        final time =
            (solve['solve_time'] as int) / 1000.0; // Convert ms to seconds
        final isDnf = (solve['is_dnf'] as int) == 1;
        final dateTime = solve['date_time'] as String;
        log('Solve: ID=$id, Time=$time s, DNF=$isDnf, Date=$dateTime');
      }

      // App integration: Use in main.dart to populate a solve history ListView or
      // pass to GraphPage (convert to List<SolveData> if needed).
      // Example: setState(() => _solvesList = solves);
    } catch (e) {
      log('Error fetching solves for sessionId=$sessionId: $e');
    }
  }

  // Example for insertSession: Create a new session for a puzzle.
  static Future<void> exampleInsertSession() async {
    // Purpose: Insert a new session with a puzzle, name, and scramble type.
    // Input: puzzleId (int), sessionName (String), scrambleTypeId (int).
    // Output: int (new session_id).
    const puzzleId = 1; // 3x3 Cube
    const sessionName = 'Edges Only Session'; // Must be unique
    const scrambleTypeId = 2; // ScrambleType Edges Only (must match puzzleId)
    log('Running exampleInsertSession for $sessionName...');
    try {
      // Validate scramble type belongs to puzzle (optional, FK ensures integrity).
      final scrambleTypes = await DatabaseHelper.instance
          .getScrambleTypesByPuzzle(puzzleId);
      if (!scrambleTypes.any(
        (type) => type['scramble_type_id'] == scrambleTypeId,
      )) {
        log(
          'Scramble type ID=$scrambleTypeId not valid for puzzle ID=$puzzleId.',
        );
        return;
      }

      // Insert session
      final newSessionId = await DatabaseHelper.instance.insertSession(
        puzzleId: puzzleId,
        sessionName: sessionName,
        scrambleTypeId: scrambleTypeId,
      );

      log('Inserted session: ID=$newSessionId, Name=$sessionName');

      // Verify insertion
      final session = await DatabaseHelper.instance.getSession(newSessionId);
      if (session != null) {
        log('Verified session: ${session['session_name']}');
      }

      // App integration: Call in main.dart's _addSession after user submits a
      // with puzzle ID from _selectedPuzzleId, name from TextField, and
      // scrambleTypeId from dropdown. Update _sessions and _selectedSessionId.
    } catch (e) {
      log('Error inserting session: $e');
      // Handle in app, e.g., show error if session_name is not unique.
    }
  }

  // Example for getSession: Fetch a session by ID for scramble generation.
  static Future<void> exampleGetSession() async {
    // Purpose: Fetch a session's details, e.g., for timer_logic.dart to get
    // scramble_type_id for generating scrambles.
    // Input: sessionId (int), e.g., 1 for Default 3x3.
    // Output: Map<String, dynamic>? with session_id (int), puzzle_id (int),
    // session_name (String), scramble_type_id (int), or null if not found.
    const sessionId = 1; // Example: Default 3x3 session.
    log('Running exampleGetSession for sessionId=$sessionId...');
    try {
      final session = await DatabaseHelper.instance.getSession(sessionId);

      if (session == null) {
        log('No session found for sessionId=$sessionId.');
        return;
      }

      // Print session details
      final id = session['session_id'] as int;
      final name = session['session_name'] as String;
      final scrambleTypeId = session['scramble_type_id'] as int;
      log('Session: ID=$id, Name=$name, ScrambleTypeID=$scrambleTypeId');

      // App integration: Use in timer_logic.dart to get scramble_type_id for
      // generating puzzle-specific scrambles (e.g., WCA vs. Edges Only).
      // Example: TimerLogic.setScrambleType(session['scramble_type_id']);
    } catch (e) {
      log('Error fetching session for sessionId=$sessionId: $e');
    }
  }

  // Run all examples sequentially for testing.
  static Future<void> runAllExamples() async {
    log('Starting all database examples...');
    await exampleGetPuzzles();
    await exampleGetSessions();
    await exampleGetSessionsByPuzzle();
    await exampleGetScrambleTypesByPuzzle();
    await exampleGetSolves();
    await exampleInsertSession();
    await exampleGetSession();
    log('Completed all database examples.');
  }
}
