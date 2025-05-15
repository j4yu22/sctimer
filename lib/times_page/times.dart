import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';

class TimesPage extends StatelessWidget {
  const TimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(body: Column(children: [Text("Times page"), Footer()])),
    );
  }
}
