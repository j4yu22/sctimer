import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200], // optional: background color
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.access_alarm),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/times');
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_graph),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/graphs');
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.bar_chart),
          //   style: ButtonStyle(
          //     backgroundColor: WidgetStateProperty.all(Colors.blue),
          //     foregroundColor: WidgetStateProperty.all(Colors.white),
          //   ),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/stats');
          //   },
          // ),
        ],
      ),
    );
  }
}
