import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// DatabaseHelper manages the SQLite database for the cube timer app.
// Singleton pattern ensures one instance.
// Creates tables for puzzle, scramble_type, session, solve, tag, solve_has_tag.
// Provides methods for CRUD operations and default data insertion.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;
  static const String _dbName = 'responses.db';
  static const int _version = 1;

  DatabaseHelper._();

  // Initialize database, creating tables and default data if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Open database, create tables, and insert default data.
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    print('Database initialized at: $path');

    final db = await openDatabase(
      path,
      version: _version,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );

    // Insert default data after creation
    await _ensureDefaultData(db);
    return db;
  }

  // Create tables with foreign keys.
  Future<void> _createDB(Database db, int version) async {
    // Puzzle table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS puzzle (
        puzzle_id INTEGER PRIMARY KEY,
        puzzle_name TEXT NOT NULL
      )
    ''');

    // Scramble_Type table
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS scramble_type (
          scramble_type_id INTEGER PRIMARY KEY,
          scramble_type_name TEXT NOT NULL,
          puzzle_id INTEGER NOT NULL,
          FOREIGN KEY (puzzle_id) REFERENCES puzzle(puzzle_id)
        )
      ''');
    } catch (e) {
      print("Error creating table scramble_type, $e");
    }

    // Session table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS session (
        session_id INTEGER PRIMARY KEY AUTOINCREMENT,
        puzzle_id INTEGER NOT NULL,
        session_name TEXT NOT NULL UNIQUE,
        scramble_type_id INTEGER NOT NULL,
        FOREIGN KEY (puzzle_id) REFERENCES puzzle(puzzle_id),
        FOREIGN KEY (scramble_type_id) REFERENCES scramble_type(scramble_type_id)
      )
    ''');

    // Solve table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS solve (
        solve_id INTEGER PRIMARY KEY AUTOINCREMENT,
        solve_number INTEGER,
        solve_time INTEGER NOT NULL,
        is_dnf INTEGER NOT NULL DEFAULT 0,
        plus_two INTEGER NOT NULL DEFAULT 0,
        scramble TEXT NOT NULL,
        comment TEXT,
        date_time TEXT NOT NULL,
        session_id INTEGER NOT NULL,
        reconstruction TEXT,
        FOREIGN KEY (session_id) REFERENCES session(session_id)
      )
    ''');

    // Tag table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tag (
        tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag_name TEXT NOT NULL
      )
    ''');

    // Solve_Has_Tag table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS solve_has_tag (
        solve_id INTEGER,
        tag_id INTEGER,
        PRIMARY KEY (solve_id, tag_id),
        FOREIGN KEY (solve_id) REFERENCES solve(solve_id),
        FOREIGN KEY (tag_id) REFERENCES tag(tag_id)
      )
    ''');

    print('Database tables created');
  }

  // Insert default puzzles, scramble types, and a session.
  Future<void> _ensureDefaultData(Database db) async {
    // Insert puzzles if empty
    final puzzleCount = await db.query('puzzle');
    if (puzzleCount.isEmpty) {
      await db.insert('puzzle', {'puzzle_id': 1, 'puzzle_name': '3x3 Cube'});
      await db.insert('puzzle', {'puzzle_id': 2, 'puzzle_name': '2x2 Cube'});
      print('Inserted default puzzles');
    }

    // Insert scramble types if empty
    final scrambleTypeCount = await db.query('scramble_type');
    if (scrambleTypeCount.isEmpty) {
      await db.insert('scramble_type', {
        'scramble_type_id': 1,
        'scramble_type_name': 'WCA',
        'puzzle_id': 1,
      });
      await db.insert('scramble_type', {
        'scramble_type_id': 2,
        'scramble_type_name': 'Edges Only',
        'puzzle_id': 1,
      });
      await db.insert('scramble_type', {
        'scramble_type_id': 3,
        'scramble_type_name': 'Corners Only',
        'puzzle_id': 1,
      });
      await db.insert('scramble_type', {
        'scramble_type_id': 4,
        'scramble_type_name': 'WCA',
        'puzzle_id': 2,
      });
      print('Inserted default scramble types');
    }

    // Insert default session if empty
    final sessionCount = await db.query('session');
    if (sessionCount.isEmpty) {
      await db.insert('session', {
        'puzzle_id': 1,
        'session_name': 'Default 3x3',
        'scramble_type_id': 1,
      });
      print('Inserted default session');
    }
  }

  // Fetch all puzzles
  Future<List<Map<String, dynamic>>> getPuzzles() async {
    final db = await database;
    final puzzles = await db.query('puzzle', orderBy: 'puzzle_name ASC');
    print('Fetched ${puzzles.length} puzzles');
    return puzzles;
  }

  // Fetch all sessions
  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await database;
    final sessions = await db.query('session', orderBy: 'session_name ASC');
    print('Fetched ${sessions.length} sessions');
    return sessions;
  }

  // Fetch sessions for a specific puzzle
  Future<List<Map<String, dynamic>>> getSessionsByPuzzle(int puzzleId) async {
    final db = await database;
    final sessions = await db.query(
      'session',
      where: 'puzzle_id = ?',
      whereArgs: [puzzleId],
      orderBy: 'session_name ASC',
    );
    print('Fetched ${sessions.length} sessions for puzzle $puzzleId');
    return sessions;
  }

  // Fetch scramble types for a specific puzzle
  Future<List<Map<String, dynamic>>> getScrambleTypesByPuzzle(
    int puzzleId,
  ) async {
    final db = await database;
    final scrambleTypes = await db.query(
      'scramble_type',
      where: 'puzzle_id = ?',
      whereArgs: [puzzleId],
      orderBy: 'scramble_type_name ASC',
    );
    print(
      'Fetched ${scrambleTypes.length} scramble types for puzzle $puzzleId',
    );
    return scrambleTypes;
  }

  // Fetch solves for a specific session
  Future<List<Map<String, dynamic>>> getSolves(int sessionId) async {
    final db = await database;
    final solves = await db.query(
      'solve',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'date_time DESC',
    );
    print('Fetched ${solves.length} solves for session $sessionId');
    return solves;
  }

  // Insert a new session
  Future<int> insertSession({
    required int puzzleId,
    required String sessionName,
    required int scrambleTypeId,
  }) async {
    final db = await database;
    final sessionData = {
      'puzzle_id': puzzleId,
      'session_name': sessionName,
      'scramble_type_id': scrambleTypeId,
    };
    try {
      final id = await db.insert('session', sessionData);
      print('Inserted session: $sessionName with id $id');
      return id;
    } catch (e) {
      print('Error inserting session: $e');
      rethrow;
    }
  }

  // Get session by ID
  Future<Map<String, dynamic>?> getSession(int sessionId) async {
    final db = await database;
    final sessions = await db.query(
      'session',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      limit: 1,
    );
    print(
      'Fetched session $sessionId: ${sessions.isNotEmpty ? sessions.first : null}',
    );
    return sessions.isNotEmpty ? sessions.first : null;
  }
}
