import 'package:flutter/material.dart';

class AlarmNotePage extends StatelessWidget {
  const AlarmNotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'alarm note page',
          style: TextStyle(
            color: Theme.of(context).highlightColor,
          ),
        ),
      ),
    );
  }
}
