import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import '/data/database_helper.dart';

class HeaderUI extends StatefulWidget {
  final int? selectedSessionId;
  final Function(int?)? onSessionChanged;
  const HeaderUI({super.key, this.selectedSessionId, this.onSessionChanged});

  @override
  _HeaderUIState createState() => _HeaderUIState();
}

class _HeaderUIState extends State<HeaderUI> {
  List<Map<String, dynamic>> _puzzleList = [];
  List<Map<String, dynamic>> _sessionList = [];
  List<Map<String, dynamic>> _scrambleTypeList = [];
  int? _selectedPuzzleId;
  int? _selectedSessionId;
  int? _selectedScrambleTypeId;
  bool _isLoading = false;

  // Computed list for session dropdown, adding "Add Session" item
  List<Map<String, dynamic>> get _sessionDropdownItems {
    return [
      ..._sessionList,
      {
        'session_id': -1,
        'session_name': 'Add Session',
        'puzzle_id': 0,
        'scramble_type_id': 0,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final puzzles = await DatabaseHelper.instance.getPuzzles();
      if (puzzles.isEmpty) {
        print('No puzzles found');
        setState(() => _isLoading = false);
        return;
      }
      setState(() {
        _puzzleList = puzzles;
        _selectedPuzzleId = puzzles.first['puzzle_id'] as int;
      });
      await _loadSessions(_selectedPuzzleId!);
      if (widget.selectedSessionId != null) {
        final session = await DatabaseHelper.instance.getSession(
          widget.selectedSessionId!,
        );
        if (session != null && session['puzzle_id'] == _selectedPuzzleId) {
          setState(() {
            _selectedSessionId = session['session_id'] as int;
            _selectedScrambleTypeId = session['scramble_type_id'] as int;
          });
        } else {
          await _loadScrambleTypes(_selectedPuzzleId!);
        }
      } else {
        await _loadScrambleTypes(_selectedPuzzleId!);
      }
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSessions(int puzzleId) async {
    final sessions = await DatabaseHelper.instance.getSessionsByPuzzle(
      puzzleId,
    );
    setState(() {
      _sessionList = sessions;
      _selectedSessionId =
          sessions.isNotEmpty ? sessions.first['session_id'] as int : null;
    });
  }

  Future<void> _loadScrambleTypes(int puzzleId) async {
    final scrambleTypes = await DatabaseHelper.instance
        .getScrambleTypesByPuzzle(puzzleId);
    setState(() {
      _scrambleTypeList = scrambleTypes;
      _selectedScrambleTypeId =
          scrambleTypes.isNotEmpty
              ? scrambleTypes.first['scramble_type_id'] as int
              : null;
    });
  }

  Future<void> _addSession() async {
    String? sessionName;
    int? scrambleTypeId;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Session'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Session Name'),
                  onChanged: (value) => sessionName = value,
                ),
                _buildDropdown(
                  label: 'Scramble Type',
                  items: _scrambleTypeList,
                  valueKey: 'scramble_type_id',
                  displayKey: 'scramble_type_name',
                  value: scrambleTypeId,
                  onChanged: (value) => scrambleTypeId = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (sessionName != null &&
                      sessionName!.isNotEmpty &&
                      scrambleTypeId != null &&
                      _selectedPuzzleId != null) {
                    setState(() => _isLoading = true);
                    try {
                      final newSessionId = await DatabaseHelper.instance
                          .insertSession(
                            puzzleId: _selectedPuzzleId!,
                            sessionName: sessionName!,
                            scrambleTypeId: scrambleTypeId!,
                          );
                      await _loadSessions(_selectedPuzzleId!);
                      setState(() => _selectedSessionId = newSessionId);
                      widget.onSessionChanged?.call(newSessionId);
                      if (_sessionList.isNotEmpty) {
                        final session = await DatabaseHelper.instance
                            .getSession(newSessionId);
                        if (session != null) {
                          setState(
                            () =>
                                _selectedScrambleTypeId =
                                    session['scramble_type_id'] as int,
                          );
                        }
                      }
                    } catch (e) {
                      print('Error adding session: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add session: $e')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, dynamic>> items,
    required String valueKey,
    required String displayKey,
    required int? value,
    required Function(int?) onChanged,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButton<int>(
        value: value,
        hint: Text(label),
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox(),
        items:
            items.map((item) {
              return DropdownMenuItem<int>(
                value: item[valueKey] as int,
                child: Text(item[displayKey] as String),
              );
            }).toList(),
        onChanged: items.isNotEmpty ? onChanged : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 28,
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  Row(
                    children: [
                      _buildDropdown(
                        label: 'Puzzle',
                        items: _puzzleList,
                        valueKey: 'puzzle_id',
                        displayKey: 'puzzle_name',
                        value: _selectedPuzzleId,
                        onChanged: (value) async {
                          setState(() => _isLoading = true);
                          try {
                            setState(() {
                              _selectedPuzzleId = value;
                              _selectedSessionId = null;
                              _selectedScrambleTypeId = null;
                            });
                            widget.onSessionChanged?.call(null);
                            if (value != null) {
                              await _loadSessions(value);
                              if (_sessionList.isNotEmpty) {
                                await _loadScrambleTypes(value);
                              }
                            }
                          } catch (e) {
                            print('Error updating puzzle: $e');
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildDropdown(
                        label: 'Session',
                        items: _sessionDropdownItems,
                        valueKey: 'session_id',
                        displayKey: 'session_name',
                        value: _selectedSessionId,
                        onChanged: (value) async {
                          if (value == -1) {
                            await _addSession();
                          } else {
                            setState(() => _isLoading = true);
                            try {
                              setState(() => _selectedSessionId = value);
                              widget.onSessionChanged?.call(value);
                              if (value != null) {
                                final session = await DatabaseHelper.instance
                                    .getSession(value);
                                if (session != null) {
                                  setState(
                                    () =>
                                        _selectedScrambleTypeId =
                                            session['scramble_type_id'] as int,
                                  );
                                }
                              }
                            } catch (e) {
                              print('Error updating session: $e');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildDropdown(
                        label: 'Scramble Type',
                        items: _scrambleTypeList,
                        valueKey: 'scramble_type_id',
                        displayKey: 'scramble_type_name',
                        value: _selectedScrambleTypeId,
                        onChanged: (value) {
                          setState(() => _selectedScrambleTypeId = value);
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.build),
                    iconSize: 24,
                    onPressed: () {
                      // Handle tool press (placeholder for your intended feature)
                    },
                  ),
                ],
              ),
    );
  }
}
