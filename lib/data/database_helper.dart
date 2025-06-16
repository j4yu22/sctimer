import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sctimer/graphs_page/graph/graph_logic.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('responses.db');
    print('Database initialized at: ${await getDatabasesPath()}/responses.db');
    await _ensureDefaultData();
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    print('Foreign keys enabled');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE puzzle (
      puzzle_id INTEGER PRIMARY KEY,
      puzzle_name TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE session (
      session_id INTEGER PRIMARY KEY AUTOINCREMENT,
      puzzle_id INTEGER NOT NULL,
      session_name TEXT NOT NULL UNIQUE,
      FOREIGN KEY (puzzle_id) REFERENCES puzzle (puzzle_id)
    )
    ''');
    await db.execute('''
    CREATE TABLE solve (
      solve_id INTEGER PRIMARY KEY AUTOINCREMENT,
      solve_number INTEGER NOT NULL,
      solve_time INTEGER NOT NULL,
      is_dnf INTEGER,
      plus_two INTEGER,
      scramble TEXT NOT NULL,
      comment TEXT,
      date_time TEXT NOT NULL,
      session_id INTEGER NOT NULL,
      reconstruction TEXT,
      FOREIGN KEY (session_id) REFERENCES session (session_id)
    )
    ''');
    await db.execute('''
    CREATE TABLE tag (
      tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
      tag_name TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE solve_has_tag (
      solve_id INTEGER NOT NULL,
      tag_id INTEGER NOT NULL,
      PRIMARY KEY (solve_id, tag_id),
      FOREIGN KEY (solve_id) REFERENCES solve (solve_id),
      FOREIGN KEY (tag_id) REFERENCES tag (tag_id)
    )
    ''');
    print('Tables created: puzzle, session, solve, tag, solve_has_tag');
  }

  Future<void> _ensureDefaultData() async {
    final db = await database;
    // Insert default puzzles
    await db.insert('puzzle', {
      'puzzle_id': 1,
      'puzzle_name': '3x3 Cube',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('puzzle', {
      'puzzle_id': 2,
      'puzzle_name': '2x2 Cube',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    // Check if sessions exist
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM session');
    final sessionCount = result.first['count'] as int;
    if (sessionCount == 0) {
      await db.insert('session', {
        'puzzle_id': 1,
        'session_name': 'Default 3x3',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      print('Inserted default session: Default 3x3');
    }
  }

  Future<int> insertPuzzle(Map<String, dynamic> puzzle) async {
    final db = await database;
    final id = await db.insert(
      'puzzle',
      puzzle,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted puzzle: $puzzle');
    return id;
  }

  Future<List<Map<String, dynamic>>> getPuzzles() async {
    final db = await database;
    final puzzles = await db.query('puzzle', orderBy: 'puzzle_name ASC');
    print('Fetched ${puzzles.length} puzzles');
    return puzzles;
  }

  Future<int> insertSession(Map<String, dynamic> session) async {
    final db = await database;
    final id = await db.insert(
      'session',
      session,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    print('Inserted session: $session');
    return id;
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await database;
    final sessions = await db.query('session', orderBy: 'session_name ASC');
    print('Fetched ${sessions.length} sessions');
    return sessions;
  }

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

  Future<int> insertSolve(Map<String, dynamic> solve) async {
    final db = await database;
    final id = await db.insert(
      'solve',
      solve,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted solve: $solve');
    return id;
  }

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

  Future<int> getSolveCount(int sessionId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM solve WHERE session_id = ?',
      [sessionId],
    );
    final count = result.first['count'] as int;
    print('Solve count for session $sessionId: $count');
    return count;
  }

  Future<int> insertTag(Map<String, dynamic> tag) async {
    final db = await database;
    final id = await db.insert(
      'tag',
      tag,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted tag: $tag');
    return id;
  }

  Future<List<Map<String, dynamic>>> getTags() async {
    final db = await database;
    final tags = await db.query('tag', orderBy: 'tag_name ASC');
    print('Fetched ${tags.length} tags');
    return tags;
  }

  Future<void> insertSolveTag(int solveId, int tagId) async {
    final db = await database;
    await db.insert('solve_has_tag', {
      'solve_id': solveId,
      'tag_id': tagId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    print('Inserted solve_tag: solve_id=$solveId, tag_id=$tagId');
  }

  Future<List<Map<String, dynamic>>> getTagsForSolve(int solveId) async {
    final db = await database;
    final tags = await db.rawQuery(
      '''
      SELECT tag.* FROM tag
      JOIN solve_has_tag ON tag.tag_id = solve_has_tag.tag_id
      WHERE solve_has_tag.solve_id = ?
    ''',
      [solveId],
    );
    print('Fetched ${tags.length} tags for solve $solveId');
    return tags;
  }

  Future<List<SolveData>> getSolveDataList(int sessionId) async {
    final rawSolves = await getSolves(sessionId);

    return rawSolves.map((row) => SolveData(
      solveNumber: row['solve_num'],
      sessionId: row['session_id'],
      solveTime: row['solve_time'],
      isDNF: (row['is_dnf'] ?? 0) == 1,
      plusTwo: (row['plus_two'] ?? 0) == 1,
      dateTime: DateTime.parse(row['date_time']),
      scramble: row['scramble'] ?? '',
      reconstruction: row['reconstruction'] ?? '',
      comment: row['comment'] ?? '',
    )).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    print('Database closed');
  }
}
