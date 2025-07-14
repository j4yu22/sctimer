import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';
import 'package:sctimer/header/header_ui.dart';
import '../../data/database_helper.dart';

class TimesPage extends StatelessWidget {
  const TimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [HeaderUI(), Expanded(child: SliverGridWidget()), Footer()],
        ),
      ),
    );
  }
}

class TimeBlock extends StatelessWidget {
  late String _time;
  late String _comment;
  late String _penalty;
  late String _date;
  late int _solveIdPK;
  late String _scramble = "";
  late bool _dnf;

  // The _solveIdPK is used to look up the solve in the SQL database after the timeblock widget is created
  // This is used for the click event on the InkWell when it opens the floating dialogue box to show more info about the solve

  TimeBlock({
    super.key,
    int pk = 0,
    int time = 0,
    String comment = "",
    String scramble = "",
    int penalty = 0,
    String date = "0/0/0",
    bool dnf = false,
  }) {
    if (time < 1000) {
      _time =
          '0'
              "." +
          time.toString();
    } else if (time > 60000) {
      int start = (time / 60000).floor();
      int middle = ((time % 60000) / 1000).floor();
      int end = (time % 60000) % 1000;
      _time = "$start:$middle.$end";
    } else {
      int middle = ((time % 60000) / 1000).floor();
      int end = (time % 60000) % 1000;
      _time = "$middle.$end";
    }
    _comment = comment;
    if (penalty != 0) {
      penalty = penalty * 2;
      _penalty = "   +$penalty";
    } else {
      _penalty = "";
    }
    _scramble = scramble;
    _date = date.replaceRange(10, date.length, '');
    _comment = comment;
    _solveIdPK = pk;
    _dnf = dnf;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          _floatingTimeBlockBuilder(
            context,
            _penalty,
            _date,
            _scramble,
            _comment,
            _time.toString(),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 40,
        margin: EdgeInsets.all(7),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(_date, textScaler: TextScaler.linear(.75)),
                Expanded(child: Container()),
                Text(_penalty),
              ],
            ),
            Row(
              children: [
                Center(
                  child: Text(
                    _time.toString(),
                    textScaler: TextScaler.linear(1.5),
                  ),
                ),
                Expanded(child: Container()),
                Icon(
                  Icons.comment,
                  size: 12,
                  color: const Color.fromARGB(255, 16, 97, 163),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Route<Object?> _floatingTimeBlockBuilder(
    BuildContext context,
    String penalty,
    String date,
    String scramble,
    String comment,
    String time,
  ) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(time),
                  Text(penalty, style: TextStyle(color: Colors.red)),
                  Spacer(),
                  Text(date),
                ],
              ),
              Text(scramble, softWrap: true),
              Text(comment),
              Row(
                children: [
                  IconButton(onPressed: null, icon: Icon(Icons.delete)),
                  IconButton(onPressed: null, icon: Icon(Icons.move_down)),
                  Spacer(),
                  IconButton(onPressed: null, icon: Icon(Icons.comment)),
                  IconButton(onPressed: null, icon: Icon(Icons.flag)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SliverGridWidget extends StatefulWidget {
  const SliverGridWidget({super.key});

  @override
  State<SliverGridWidget> createState() => SliverGridState();
}

class SliverGridState extends State<SliverGridWidget> {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  final timeBlockList = <TimeBlock>[
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble:
    //       "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U ",
    //   comment: "This is a test comment.",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    //   comment:
    //       "This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. This is a much longer test comment. ",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 2,
    //   time: 8.31,
    //   date: "4/16/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 3.35,
    //   date: "4/30/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 9.05,
    //   date: "5/05/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 1,
    //   time: 15.72,
    //   date: "5/07/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
    // TimeBlock(
    //   penalty: 0,
    //   time: 7.99,
    //   date: "5/15/2025",
    //   scramble: "U B2 L2 R2 D L2 U' B2 R' U2 L' U B F2 R' U' F' U",
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMoreItems();

    scrollController.addListener(() {
      // Check if we are close to the bottom
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading) {
        // _loadMoreItems();
      }
    });
  }

  void _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> solves = await DatabaseHelper.instance.getSolves(
      1,
    );
    print('Getting solves to display');
    for (var solve in solves) {
      print(solve);
      bool dnf = solve['is_dnf'] != 0;
      timeBlockList.add(
        TimeBlock(
          pk: solve['solve_id'],
          time: solve['solve_time'],
          comment: solve['comment'],
          scramble: solve['scramble'],
          penalty: solve['plus_two'],
          date: solve['date_time'],
          dnf: dnf,

          //       int pk = 0,
          // double time = 0,
          // String comment = "",
          // String scramble = "",
          // int penalty = 0,
          // String date = "0/0/0",
          // bool dnf = false,
        ),
      );
    }
    // Inside the addAll method is where the new timeblocks should be added
    timeBlockList.addAll([]);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ← Add this line
      child: GridView(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 80.0,
        ),
        children: timeBlockList,
      ),
    );
  }
}
